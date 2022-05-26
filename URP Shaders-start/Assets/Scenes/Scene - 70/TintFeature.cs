using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace ShadersLearn
{
    public class TintFeature : ScriptableRendererFeature
    {
        private class CustomRenderPass : ScriptableRenderPass
        {
            private readonly Material material;
            private RenderTargetHandle temp;

            public RenderTargetIdentifier Source { get; set; }

            public CustomRenderPass(Material material)
            {
                this.material = material;
                this.temp.Init("_TempTintFeature");
            }

            public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
            {
                RenderTextureDescriptor textureDescriptor = renderingData.cameraData.cameraTargetDescriptor;
                textureDescriptor.depthBufferBits = 0;
                cmd.GetTemporaryRT(this.temp.id, textureDescriptor, FilterMode.Bilinear);
            }

            public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
            {
                CommandBuffer cmd = CommandBufferPool.Get("TintFeature");
                Blit(cmd, this.Source, this.temp.Identifier(), this.material);
                Blit(cmd, this.temp.Identifier(), this.Source);
                context.ExecuteCommandBuffer(cmd);
                CommandBufferPool.Release(cmd);
            }

            public override void OnCameraCleanup(CommandBuffer cmd)
            {
                cmd.ReleaseTemporaryRT(this.temp.id);
            }
        }

        [SerializeField]
        private Material material;

        private CustomRenderPass scriptablePass;

        public override void Create()
        {
            this.scriptablePass = new(this.material)
            {
                renderPassEvent = RenderPassEvent.AfterRenderingOpaques
            };
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            this.scriptablePass.Source = renderer.cameraColorTarget;
            renderer.EnqueuePass(this.scriptablePass);
        }
    }
}


