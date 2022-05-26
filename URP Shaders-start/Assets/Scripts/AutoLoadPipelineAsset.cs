using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace ShadersLearn
{
    [ExecuteAlways]
    public class AutoLoadPipelineAsset : MonoBehaviour
    {
        [SerializeField]
        private UniversalRenderPipelineAsset pipelineAsset;

        // Start is called before the first frame update
        private void OnEnable()
        {
            if (this.pipelineAsset)
            {
                GraphicsSettings.renderPipelineAsset = this.pipelineAsset;
            }
        }
    }
}
