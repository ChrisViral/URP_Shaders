using UnityEngine;
using UnityEngine.AI;

namespace ShadersLearn
{
    [RequireComponent(typeof (NavMeshAgent), typeof(Animator))]
    public class GirlController : MonoBehaviour
    {
        private static readonly int Position = Shader.PropertyToID("_Position");
        private static readonly int Speed = Animator.StringToHash("speed");

        [SerializeField]
        private Material material;

        private Animator anim;
        private Camera cam;
        private NavMeshAgent agent;
        private Vector2 smoothDeltaPosition;
        private Vector2 velocity;

        private void Awake()
        {
            this.anim  = GetComponent<Animator>();
            this.agent = GetComponent<NavMeshAgent>();
            this.cam   = Camera.main;
            // Don’t update position automatically
            this.agent.updatePosition = false;

            FindAndSelectMaterial();
        }

        private void FindAndSelectMaterial()
        {
            GameObject plane = GameObject.Find("Plane");
            if (!plane) return;

            this.material = plane.GetComponent<Renderer>().material;
            if (!this.material) return;

            this.material.SetVector(Position, this.transform.position);
        }

        private void Update()
        {
            if (Input.GetMouseButtonDown(0))
            {
                Ray ray = this.cam.ScreenPointToRay(Input.mousePosition);

                if (Physics.Raycast(ray, out RaycastHit hit))
                {
                    this.agent.destination = hit.point;
                    if (this.material)
                    {
                        this.material.SetVector(Position, hit.point);
                    }
                }
            }

            // ReSharper disable once LocalVariableHidesMember
            Transform transform = this.transform;
            Vector3 worldDeltaPosition = this.agent.nextPosition - transform.position;

            // Map 'worldDeltaPosition' to local space
            float dx = Vector3.Dot(transform.right, worldDeltaPosition);
            float dy = Vector3.Dot(transform.forward, worldDeltaPosition);
            Vector2 deltaPosition = new(dx, dy);

            // Low-pass filter the deltaMove
            float smooth = Mathf.Min(1.0f, Time.deltaTime / 0.15f);
            this.smoothDeltaPosition = Vector2.Lerp(this.smoothDeltaPosition, deltaPosition, smooth);

            // Update velocity if time advances
            if (Time.deltaTime > 1e-5f)
            {
                this.velocity = this.smoothDeltaPosition / Time.deltaTime;
            }

            float speed = this.velocity.magnitude;
            // Update animation parameters
            this.anim.SetFloat(Speed, speed);
        }

        private void OnAnimatorMove()
        {
            // Update position to agent position
            this.transform.position = this.agent.nextPosition;
        }
    }
}
