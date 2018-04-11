using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class DebugMaterialEditor : ShaderGUI
{
    public enum DebugMode
    {
        COLOR_RAW = 0,
        NORMAL_RAW,
        UV_RAW,
        UV_CHECKER,
    }

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        Material targetMat = materialEditor.target as Material;
        DebugMode debugMode = (DebugMode)targetMat.GetInt("_Mode");
        float uvCheckerResolution = targetMat.GetFloat("_UvCheckerResolution");

        EditorGUI.BeginChangeCheck();
        debugMode = (DebugMode)EditorGUILayout.EnumPopup("Debug mode", debugMode);
        if (debugMode == DebugMode.UV_CHECKER)
        {
            uvCheckerResolution = EditorGUILayout.Slider("Resolution", uvCheckerResolution, 2, 50);
        }
        uvCheckerResolution = Mathf.FloorToInt(uvCheckerResolution);
        uvCheckerResolution = uvCheckerResolution - (uvCheckerResolution % 2);
        uvCheckerResolution = Mathf.Max(2, uvCheckerResolution);
        if (EditorGUI.EndChangeCheck())
        {
            targetMat.SetInt("_Mode", (int)debugMode);
            targetMat.SetFloat("_UvCheckerResolution", uvCheckerResolution);
        }
    }
}
