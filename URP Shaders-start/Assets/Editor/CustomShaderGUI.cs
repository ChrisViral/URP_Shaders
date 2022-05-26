using System;
using UnityEditor;
using UnityEngine;

namespace ShadersLearn.Editor
{
    public class CustomShaderGUI : ShaderGUI
    {
        // ReSharper disable IdentifierTypo StringLiteralTypo
        private const string REDIFY = "_REDIFY";

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            // Render the default gui
            base.OnGUI(materialEditor, properties);

            Material material = (Material)materialEditor.target;
            using EditorGUI.ChangeCheckScope change = new();
            bool redify = Array.IndexOf(material.shaderKeywords, REDIFY) is not -1;
            redify = EditorGUILayout.Toggle("Redify", redify);

            if (!change.changed) return;

            if (redify)
            {
                material.EnableKeyword(REDIFY);
            }
            else
            {
                material.DisableKeyword(REDIFY);
            }
        }
    }
}