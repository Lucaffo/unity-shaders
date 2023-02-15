using UnityEngine;
using UnityEngine.UI;

namespace Shaders.Esercizio_17
{
    public class HealthBar : MonoBehaviour
    {
        [SerializeField]
        private Image healthBarImage;

        [SerializeField]
        private float health;

        private Material _healthBarMaterial;
        private static readonly int HealthValue = Shader.PropertyToID("HealthValue");

        private void Awake()
        {
            _healthBarMaterial = new Material(healthBarImage.material);
        }

        [ContextMenu("SetHealthValue")]
        public void SetHealthToTarget()
        {
            SetHealthBar(health);
        }
        
        private void SetHealthBar(float healthValue)
        {
            _healthBarMaterial.SetFloat(HealthValue, healthValue);
        }
    }
}
