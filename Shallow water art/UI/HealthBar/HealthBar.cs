using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HealthBar : MonoBehaviour
{
    public Slider slider;
    [SerializeField] Image fill;

    [SerializeField] Gradient gradient;


    public void SetMaxHealth(int health)
    {
        slider.maxValue = health;

        fill.color = gradient.Evaluate(1f);
    }

    public void SetHealth(int health)
    {
        slider.value = health;

        fill.color = gradient.Evaluate(slider.normalizedValue);
    }

    public bool TrueUnderPercentage(float percentage)
    {
        return slider.value <= slider.maxValue * percentage;
    }

}
