using System;
using UnityEngine;

namespace ShadersLearn
{
    public class SphereBounce : MonoBehaviour
    {
        private float startY;

        private void Awake()
        {
            this.startY = this.transform.position.y;
        }

        private void Update()
        {
            Vector3 position = this.transform.position;
            position.y = this.startY + (Mathf.Sin(Time.time * 3f) * 0.2f);
            this.transform.position = position;
        }
    }
}
