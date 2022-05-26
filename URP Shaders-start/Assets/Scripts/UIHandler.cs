using UnityEngine;

namespace ShadersLearn
{
    public class UIHandler : MonoBehaviour
    {
        private static readonly int StartTime = Shader.PropertyToID("_StartTime");
        private static readonly int TextureA  = Shader.PropertyToID("_TextureA");
        private static readonly int TextureB  = Shader.PropertyToID("_TextureB");

        [SerializeField]
        private GameObject quad;
        [SerializeField]
        private Texture[] images;

        private int index;
        private Material material;

        // Start is called before the first frame update
        private void Start()
        {
            this.index = 0;

            if (!this.quad) return;

            this.material = this.quad.GetComponent<Renderer>().material;
            this.material.SetFloat(StartTime, Time.time);
            NextClicked();
        }

        public void NextClicked()
        {
            if (!this.material) return;

            this.index++;
            if (this.index >= this.images.Length)
            {
                this.index = 0;
            }

            if (this.index == 0)
            {
                this.material.SetTexture(TextureA, this.images[^1]);
                this.material.SetTexture(TextureB, this.images[this.index]);
            }
            else
            {
                this.material.SetTexture(TextureA, this.images[this.index - 1]);
                this.material.SetTexture(TextureB, this.images[this.index]);
            }

            this.material.SetFloat(StartTime, Time.time);
        }
    }
}
