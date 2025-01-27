﻿using UnityEngine;
using UnityEditor;
using System;

public class CustomShaderGUI : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        // render the default gui
        base.OnGUI(materialEditor, properties);

        Material targetMat = materialEditor.target as Material;

        // see if redify is set, and show a checkbox
        bool redify = Array.IndexOf(targetMat.shaderKeywords, "_REDIFY") != -1;
        EditorGUI.BeginChangeCheck();
        redify = EditorGUILayout.Toggle("Redify material", redify);
        if (EditorGUI.EndChangeCheck())
        {
            // enable or disable the keyword based on checkbox
            if (redify)
                targetMat.EnableKeyword("_REDIFY");
            else
                targetMat.DisableKeyword("_REDIFY");
        }
    }
}