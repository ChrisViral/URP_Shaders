using UnityEngine;

namespace ShadersLearn
{
    public class TrackMouse : MonoBehaviour
    {
        private static readonly int Mouse = Shader.PropertyToID("_Mouse");

        private Material material;
        private Vector4 mouse;
        private Camera cam;

        private void Awake()
        {
            Renderer rend = GetComponent<Renderer>();
            this.material = rend.material;
            this.mouse.z = Screen.height;
            this.mouse.w = Screen.width;
            this.cam = Camera.main;
        }

        private void Update()
        {
            Ray ray = this.cam.ScreenPointToRay(Input.mousePosition);

            if (Physics.Raycast(ray, out RaycastHit hit))
            {
                this.mouse.x = hit.textureCoord.x;
                this.mouse.y = hit.textureCoord.y;
            }

            this.material.SetVector(Mouse, this.mouse);
        }
    }
}
