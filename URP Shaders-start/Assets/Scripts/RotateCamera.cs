using UnityEngine;

namespace ShadersLearn
{
    public class RotateCamera : MonoBehaviour
    {
        [SerializeField]
        private Transform target;

        private Transform control;

        private void Start()
        {
            if (this.target == null) return;

            this.control = new GameObject().transform;
            this.control.position = this.target.position;
            this.transform.SetParent(this.control);
        }

        private void Update()
        {
            if (this.target)
            {
                this.control.Rotate(Vector3.up, Time.deltaTime * 10f);
            }
        }
    }
}
