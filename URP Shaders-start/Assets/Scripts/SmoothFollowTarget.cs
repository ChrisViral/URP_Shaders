using UnityEngine;

namespace ShadersLearn
{
    public class SmoothFollowTarget : MonoBehaviour
    {
        [SerializeField]
        private GameObject target;
        [SerializeField]
        private Vector2 limitsX = new(float.NegativeInfinity, float.PositiveInfinity);

        private Vector3? offset;

        private void LateUpdate()
        {
            if (!this.target)
            {
                this.target = GameObject.FindGameObjectWithTag("Player");
                if (!this.target) return;
            }

            Vector3 position = this.transform.position;
            Vector3 targetPosition = this.target.transform.position;
            this.offset ??= position - targetPosition;
            Vector3 pos = targetPosition + this.offset.Value;
            pos.x = Mathf.Clamp(pos.x, this.limitsX.x, this.limitsX.y);
            this.transform.position = Vector3.Lerp(position, pos, Time.deltaTime * 5f);
            this.transform.LookAt(this.target.transform);
        }
    }
}
