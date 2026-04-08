using UnityEngine;
using UnityEngine.Serialization;

[RequireComponent(typeof(Rigidbody))]
public class PlayerMovement : MonoBehaviour
{
    [Header("Movement")]
    public float moveSpeed = 2f;
    public float jumpForce = 3f;
    public KeyCode jumpKey = KeyCode.Space;
    public float coyoteTime = 0.12f;
    public float jumpGroundLockTime = 0.15f;
    public float landingResetTolerance = 0.08f;
    public int requiredGroundedFrames = 2;

    [Header("Ground Snap")]
    public float groundSnapOffset = 0.6f;
    public float raycastLength = 10f;
    public float maxSnapDistance = 1.5f;
    public float snapActivationDistance = 0.35f;
    public float snapSmoothSpeed = 6f;
    public float groundedTolerance = 0.2f;
    public LayerMask terrainLayer;

    [Header("Visuals")]
    public SpriteRenderer playerSprite;

    [Header("Animation")]
    public Animator playerAnimator;
    public string runningBoolName = "isRunning";
    public string jumpBoolName = "isJumping";
    [FormerlySerializedAs("rollTriggerName")]
    [FormerlySerializedAs("defenseTriggerName")]
    public string defenseBoolName = "defense";
    public string attackBoolName = "attack";
    public string attackThreeBoolName = "attack3";
    public float runStopDelay = 0.08f;
    public KeyCode attackKey = KeyCode.E;
    public KeyCode attackThreeKey = KeyCode.Q;
    public float attackDuration = 0.2f;
    public float attackThreeDuration = 0.18f;
    public float attackCooldown = 0.12f;

    [Header("Defense Visuals")]
    [FormerlySerializedAs("rollVisualDrop")]
    public float defenseVisualDrop = 0.12f;
    [FormerlySerializedAs("rollVisualDropSpeed")]
    public float defenseVisualDropSpeed = 12f;

    private Rigidbody rb;
    private CapsuleCollider playerCollider;
    private Vector3 moveInput;
    private bool jumpRequested;
    private float coyoteTimer;
    private bool jumpConsumed;
    private float jumpGroundLockTimer;
    private int groundedFrameCounter;
    private bool warnedMissingTerrainLayer;
    private int runningBoolHash;
    private bool canDriveRunningBool;
    private int jumpBoolHash;
    private bool canDriveJumpBool;
    private int defenseBoolHash;
    private bool canDriveDefenseBool;
    private int attackBoolHash;
    private bool canDriveAttackBool;
    private int attackThreeBoolHash;
    private bool canDriveAttackThreeBool;
    private float runStopTimer;
    private float attackActiveTimer;
    private float attackCooldownTimer;
    private float currentDefenseVisualDrop;
    private float facingX = 1f;
    private float lockedZPosition;
    private Vector3 baseColliderCenter;
    private readonly int attackStateNameHash = Animator.StringToHash("Base Layer.Attack");
    private readonly int attackThreeStateNameHash = Animator.StringToHash("Base Layer.Attack3");
    private int activeAttackBoolHash;
    private bool isDefending;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        attackKey = KeyCode.E;
        attackThreeKey = KeyCode.Q;
        playerCollider = GetComponent<CapsuleCollider>();
        lockedZPosition = rb.position.z;
        rb.constraints |= RigidbodyConstraints.FreezePositionZ;
        if (playerCollider != null)
        {
            baseColliderCenter = playerCollider.center;
        }

        if (playerSprite == null)
        {
            playerSprite = GetComponentInChildren<SpriteRenderer>();
            if (playerSprite == null)
            {
                Debug.LogWarning("PlayerMovement: No SpriteRenderer assigned/found. Sprite flip will not work.");
            }
        }

        if (playerAnimator == null)
        {
            playerAnimator = GetComponentInChildren<Animator>();
        }

        if (playerAnimator != null && !string.IsNullOrWhiteSpace(runningBoolName))
        {
            runningBoolHash = Animator.StringToHash(runningBoolName);
            canDriveRunningBool = HasParameter(playerAnimator, runningBoolHash, AnimatorControllerParameterType.Bool);
            if (!canDriveRunningBool)
            {
                Debug.LogWarning($"PlayerMovement: Animator is missing bool parameter '{runningBoolName}'.");
            }
        }

        if (playerAnimator != null && !string.IsNullOrWhiteSpace(jumpBoolName))
        {
            jumpBoolHash = Animator.StringToHash(jumpBoolName);
            canDriveJumpBool = HasParameter(playerAnimator, jumpBoolHash, AnimatorControllerParameterType.Bool);
            if (!canDriveJumpBool)
            {
                Debug.LogWarning($"PlayerMovement: Animator is missing bool parameter '{jumpBoolName}'.");
            }
        }

        if (playerAnimator != null && !string.IsNullOrWhiteSpace(defenseBoolName))
        {
            defenseBoolHash = Animator.StringToHash(defenseBoolName);
            canDriveDefenseBool = HasParameter(playerAnimator, defenseBoolHash, AnimatorControllerParameterType.Bool);
            if (!canDriveDefenseBool)
            {
                Debug.LogWarning($"PlayerMovement: Animator is missing bool parameter '{defenseBoolName}'.");
            }
        }

        if (playerAnimator != null && !string.IsNullOrWhiteSpace(attackBoolName))
        {
            attackBoolHash = Animator.StringToHash(attackBoolName);
            canDriveAttackBool = HasParameter(playerAnimator, attackBoolHash, AnimatorControllerParameterType.Bool);
            if (!canDriveAttackBool)
            {
                Debug.LogWarning($"PlayerMovement: Animator is missing bool parameter '{attackBoolName}'.");
            }
        }

        if (playerAnimator != null && !string.IsNullOrWhiteSpace(attackThreeBoolName))
        {
            attackThreeBoolHash = Animator.StringToHash(attackThreeBoolName);
            canDriveAttackThreeBool = HasParameter(playerAnimator, attackThreeBoolHash, AnimatorControllerParameterType.Bool);
            if (!canDriveAttackThreeBool)
            {
                Debug.LogWarning($"PlayerMovement: Animator is missing bool parameter '{attackThreeBoolName}'.");
            }
        }
    }

    void Update()
    {
        float moveX = Input.GetAxisRaw("Horizontal");

        moveInput = new Vector3(moveX, 0f, 0f).normalized;

        if (moveInput.sqrMagnitude > 0.0001f)
        {
            runStopTimer = runStopDelay;
        }
        else
        {
            runStopTimer -= Time.deltaTime;
            if (runStopTimer < 0f)
            {
                runStopTimer = 0f;
            }
        }

        if (attackActiveTimer > 0f)
        {
            attackActiveTimer -= Time.deltaTime;
            if (attackActiveTimer < 0f)
            {
                attackActiveTimer = 0f;
            }
        }

        if (attackCooldownTimer > 0f)
        {
            attackCooldownTimer -= Time.deltaTime;
            if (attackCooldownTimer < 0f)
            {
                attackCooldownTimer = 0f;
            }
        }

        UpdateDefenseState();
        UpdateAttackState();

        if (Input.GetKeyDown(jumpKey))
        {
            jumpRequested = true;
        }

        UpdateSpriteDirection();
        UpdateAnimatorState();
    }

    void UpdateDefenseState()
    {
        isDefending = Input.GetKey(KeyCode.LeftShift) || Input.GetKey(KeyCode.RightShift);

        if (!canDriveDefenseBool)
        {
            return;
        }

        if (isDefending && attackActiveTimer > 0f)
        {
            StopActiveAttack();
        }

        playerAnimator.SetBool(defenseBoolHash, isDefending);
    }

    void UpdateAttackState()
    {
        if (!canDriveAttackBool && !canDriveAttackThreeBool)
        {
            return;
        }

        if (attackActiveTimer <= 0f)
        {
            StopActiveAttack();
        }

        bool attackPressed = Input.GetKeyDown(KeyCode.E) || (attackKey != KeyCode.E && Input.GetKeyDown(attackKey));
        bool attackThreePressed = Input.GetKeyDown(KeyCode.Q) || (attackThreeKey != KeyCode.Q && Input.GetKeyDown(attackThreeKey));
        if (isDefending || IsJumpingForAnimation() || attackActiveTimer > 0f || attackCooldownTimer > 0f)
        {
            return;
        }

        if (attackThreePressed && canDriveAttackThreeBool)
        {
            StartAttack(attackThreeBoolHash, attackThreeDuration, attackThreeStateNameHash);
            return;
        }

        if (attackPressed)
        {
            StartAttack(attackBoolHash, attackDuration, attackStateNameHash);
        }
    }

    void FixedUpdate()
    {
        if (jumpGroundLockTimer > 0f)
        {
            jumpGroundLockTimer -= Time.fixedDeltaTime;
            if (jumpGroundLockTimer < 0f)
            {
                jumpGroundLockTimer = 0f;
            }
        }

        UpdateDefenseVisualDrop();
        UpdateGroundedTimer();
        TryJump();
        ApplyMovement();
        SnapToGround();
    }

    void UpdateDefenseVisualDrop()
    {
        float targetDrop = isDefending ? defenseVisualDrop : 0f;
        float previousDrop = currentDefenseVisualDrop;
        currentDefenseVisualDrop = Mathf.MoveTowards(
            currentDefenseVisualDrop,
            targetDrop,
            defenseVisualDropSpeed * Time.fixedDeltaTime
        );

        float dropDelta = currentDefenseVisualDrop - previousDrop;
        if (!Mathf.Approximately(dropDelta, 0f))
        {
            Vector3 position = rb.position;
            position.y -= dropDelta;
            rb.MovePosition(position);
        }

        if (playerCollider != null)
        {
            Vector3 colliderCenter = baseColliderCenter;
            colliderCenter.y += currentDefenseVisualDrop;
            playerCollider.center = colliderCenter;
        }
    }

    void UpdateGroundedTimer()
    {
        if (jumpGroundLockTimer > 0f)
        {
            groundedFrameCounter = 0;
            coyoteTimer -= Time.fixedDeltaTime;
            if (coyoteTimer < 0f)
            {
                coyoteTimer = 0f;
            }
            return;
        }

        bool groundedNow = IsGrounded() && rb.linearVelocity.y <= 0.05f;
        if (groundedNow)
        {
            groundedFrameCounter++;
            coyoteTimer = coyoteTime;
            if (groundedFrameCounter >= requiredGroundedFrames)
            {
                jumpConsumed = false;
            }
        }
        else
        {
            groundedFrameCounter = 0;
            coyoteTimer -= Time.fixedDeltaTime;
            if (coyoteTimer < 0f)
            {
                coyoteTimer = 0f;
            }
        }
    }

    void TryJump()
    {
        if (!jumpRequested)
        {
            return;
        }

        if (!jumpConsumed && coyoteTimer > 0f)
        {
            Vector3 velocity = rb.linearVelocity;
            velocity.y = jumpForce;
            rb.linearVelocity = velocity;
            coyoteTimer = 0f;
            jumpConsumed = true;
            jumpGroundLockTimer = jumpGroundLockTime;
            groundedFrameCounter = 0;
        }

        jumpRequested = false;
    }

    void ApplyMovement()
    {
        Vector3 velocity = new Vector3(
            moveInput.x * moveSpeed,
            rb.linearVelocity.y,
            0f
        );

        rb.linearVelocity = velocity;

        Vector3 position = rb.position;
        if (!Mathf.Approximately(position.z, lockedZPosition))
        {
            position.z = lockedZPosition;
            rb.MovePosition(position);
        }
    }

    void SnapToGround()
    {
        if (jumpGroundLockTimer > 0f)
        {
            return;
        }

        if (TryGetGroundHit(out RaycastHit hit))
        {
            if (rb.linearVelocity.y > 0.01f)
            {
                return;
            }

            Vector3 bodyPosition = GetBodyPosition();
            float targetBodyY = hit.point.y + groundSnapOffset;
            float targetY = targetBodyY - currentDefenseVisualDrop;
            float distanceAboveGround = bodyPosition.y - targetBodyY;

            if (distanceAboveGround > maxSnapDistance)
            {
                return;
            }

            // Let gravity handle larger drops; only blend when close to the ground.
            if (distanceAboveGround > snapActivationDistance)
            {
                return;
            }

            Vector3 snappedPosition = rb.position;
            float t = 1f - Mathf.Exp(-snapSmoothSpeed * Time.fixedDeltaTime);
            snappedPosition.y = Mathf.Lerp(rb.position.y, targetY, t);
            rb.MovePosition(snappedPosition);

            if (Mathf.Abs(snappedPosition.y - targetY) <= 0.01f && rb.linearVelocity.y < 0f)
            {
                Vector3 velocity = rb.linearVelocity;
                velocity.y = 0f;
                rb.linearVelocity = velocity;
            }
        }
    }

    bool IsGrounded()
    {
        if (TryGetGroundHit(out RaycastHit hit))
        {
            float distanceToGround = GetBodyPosition().y - hit.point.y;
            float distanceFromTargetOffset = Mathf.Abs(distanceToGround - groundSnapOffset);
            float strictTolerance = Mathf.Min(groundedTolerance, landingResetTolerance);
            return distanceFromTargetOffset <= strictTolerance;
        }

        return false;
    }

    bool TryGetGroundHit(out RaycastHit groundHit)
    {
        int layerMask = terrainLayer.value;
        if (layerMask == 0)
        {
            layerMask = Physics.DefaultRaycastLayers;
            if (!warnedMissingTerrainLayer)
            {
                Debug.LogWarning("PlayerMovement: Terrain Layer is set to Nothing. Using default raycast layers as fallback.");
                warnedMissingTerrainLayer = true;
            }
        }

        Vector3 rayOrigin = GetBodyPosition() + Vector3.up * 0.5f;
        RaycastHit[] hits = Physics.RaycastAll(
            rayOrigin,
            Vector3.down,
            raycastLength + 0.5f,
            layerMask,
            QueryTriggerInteraction.Ignore
        );

        float closestDistance = float.PositiveInfinity;
        int closestHitIndex = -1;

        for (int i = 0; i < hits.Length; i++)
        {
            Collider hitCollider = hits[i].collider;
            if (hitCollider == null)
            {
                continue;
            }

            if (hitCollider.attachedRigidbody == rb || hitCollider.transform.IsChildOf(transform))
            {
                continue;
            }

            if (hits[i].distance < closestDistance)
            {
                closestDistance = hits[i].distance;
                closestHitIndex = i;
            }
        }

        if (closestHitIndex >= 0)
        {
            groundHit = hits[closestHitIndex];
            return true;
        }

        groundHit = default;
        return false;
    }

    Vector3 GetBodyPosition()
    {
        Vector3 bodyPosition = rb.position;
        bodyPosition.y += currentDefenseVisualDrop;
        return bodyPosition;
    }

    void UpdateSpriteDirection()
    {
        if (playerSprite == null)
        {
            return;
        }

        if (moveInput.x > 0.01f)
        {
            facingX = 1f;
        }
        else if (moveInput.x < -0.01f)
        {
            facingX = -1f;
        }

        playerSprite.flipX = facingX < 0f;
    }

    void UpdateAnimatorState()
    {
        bool isJumping = IsJumpingForAnimation();

        if (canDriveJumpBool)
        {
            playerAnimator.SetBool(jumpBoolHash, isJumping);
        }

        if (!canDriveRunningBool)
        {
            return;
        }

        bool isRunning = moveInput.sqrMagnitude > 0.0001f || runStopTimer > 0f;
        playerAnimator.SetBool(runningBoolHash, isRunning);
    }

    void StartAttack(int attackBoolToSet, float duration, int stateHash)
    {
        if (attackBoolToSet == 0)
        {
            return;
        }

        StopActiveAttack();
        activeAttackBoolHash = attackBoolToSet;
        attackActiveTimer = duration;
        attackCooldownTimer = duration + attackCooldown;
        playerAnimator.SetBool(activeAttackBoolHash, true);
        playerAnimator.Play(stateHash, 0, 0f);
    }

    void StopActiveAttack()
    {
        if (activeAttackBoolHash == 0 || playerAnimator == null)
        {
            activeAttackBoolHash = 0;
            return;
        }

        playerAnimator.SetBool(activeAttackBoolHash, false);
        activeAttackBoolHash = 0;
    }

    bool IsJumpingForAnimation()
    {
        return jumpGroundLockTimer > 0f || rb.linearVelocity.y > 0.05f || !IsGrounded();
    }

    bool HasParameter(Animator animator, int paramHash, AnimatorControllerParameterType parameterType)
    {
        foreach (AnimatorControllerParameter parameter in animator.parameters)
        {
            if (parameter.nameHash == paramHash && parameter.type == parameterType)
            {
                return true;
            }
        }

        return false;
    }
}
