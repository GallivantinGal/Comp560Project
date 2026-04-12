using UnityEngine;
using UnityEngine.UI;

public class HealthBar : MonoBehaviour
{
    public Slider sliderUI;
    public Image fillBG;
    public Color minColor, maxColor;
    public float currentHealth, maxHealth = 100;

    public Transform mainCam;
    public Transform target;
    public Transform worldSpaceCanvas;
    public Vector3 offset;




    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        currentHealth = maxHealth;
        sliderUI.minValue = 0;
        sliderUI.maxValue = maxHealth;
        sliderUI.value = maxHealth;

        target = transform.parent;
        mainCam = Camera.main.transform;
        worldSpaceCanvas = GameObject.FindFirstObjectByType<Canvas>().transform;
        transform.SetParent(worldSpaceCanvas);

        //transform.rotation = Quaternion.LookRotation(transform.position - mainCam.transform.position);
        transform.position = target.position + offset;
        
    }

    public void UpdateHealth(float amount)
    {
        if (currentHealth + amount > maxHealth)
        {
            currentHealth = maxHealth;
        } else if (currentHealth + amount < 0)
        {
            currentHealth = 0;
        } else
        {
            currentHealth += amount;
        }
        
        sliderUI.value = currentHealth;
    }

    // Update is called once per frame
    void Update()
    {
        fillBG.color = Color.Lerp(minColor, maxColor, currentHealth / maxHealth);
        transform.position = target.position + offset;

        // if (Input.GetMouseButtonUp(0))
        //     UpdateHealth(-10);
        
    }
}
