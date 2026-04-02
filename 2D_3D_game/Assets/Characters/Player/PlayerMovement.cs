using UnityEngine;

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
    public float runStopDelay = 0.08f;

    private Rigidbody rb;
    private Vector3 moveInput;
    private bool jumpRequested;
    private float coyoteTimer;
    private bool jumpConsumed;
    private float jumpGroundLockTimer;
    private int groundedFrameCounter;
    private bool warnedMissingTerrainLayer;
    private int runningBoolHash;
    private bool canDriveRunningBool;
    private float runStopTimer;
    private float facingX = 1f;

    void Start()
    {
        rb = GetComponent<Rigidbody>();

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
            canDriveRunningBool = HasBoolParameter(playerAnimator, runningBoolHash);
            if (!canDriveRunningBool)
            {
                Debug.LogWarning($"PlayerMovement: Animator is missing bool parameter '{runningBoolName}'.");
            }
        }
    }

    void Update()
    {
        float moveX = Input.GetAxisRaw("Horizontal");
        float moveZ = Input.GetAxisRaw("Vertical");

        moveInput = new Vector3(moveX, 0f, moveZ).normalized;

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

        if (Input.GetKeyDown(jumpKey))
        {
            jumpRequested = true;
        }

        UpdateSpriteDirection();
        UpdateAnimatorState();
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

        UpdateGroundedTimer();
        TryJump();
        ApplyMovement();
        SnapToGround();
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
            moveInput.z * moveSpeed
        );

        rb.linearVelocity = velocity;
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

            float targetY = hit.point.y + groundSnapOffset;
            float distanceAboveGround = rb.position.y - targetY;

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
            float distanceToGround = rb.position.y - hit.point.y;
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

        Vector3 rayOrigin = rb.position + Vector3.up * 0.5f;
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
        if (!canDriveRunningBool)
        {
            return;
        }

        bool isRunning = moveInput.sqrMagnitude > 0.0001f || runStopTimer > 0f;
        playerAnimator.SetBool(runningBoolHash, isRunning);
    }

    bool HasBoolParameter(Animator animator, int paramHash)
    {
        foreach (AnimatorControllerParameter parameter in animator.parameters)
        {
            if (parameter.nameHash == paramHash && parameter.type == AnimatorControllerParameterType.Bool)
            {
                return true;
            }
        }

        return false;
    }
}
