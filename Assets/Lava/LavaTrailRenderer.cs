using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LavaTrailRenderer: MonoBehaviour
{
    public Shader splatShader;
    RenderTexture _mask;
    Material _mat;
    public Material lava;
    public Transform t;
    Vector3 _oldPos;
    Vector3 _vel;
    // Start is called before the first frame update
    void Start()
    {
        _mat = new Material(splatShader);
        _mask = new RenderTexture(1024, 1024, 0, RenderTextureFormat.ARGBHalf);
        RenderTexture rt = RenderTexture.active;
        RenderTexture.active = _mask;
        GL.Clear(true, true, Color.clear);
        RenderTexture.active = rt;
        lava.SetTexture("_RenderTex", _mask);

    }
    // Update is called once per frame
    void Update()
    {

        lava.SetVector("_Offset", new Vector4(t.position.x, t.position.z, .1f, .1f));
        _mat.SetVector("_Velocity", t.position - _oldPos);
        if (t.position.y > 0.5f)
        {
            _mat.SetFloat("_Size", 0);
        }
        else
        {
            _mat.SetFloat("_Size", (1-t.position.y)*.8f);
        }
        
        RenderTexture rt = RenderTexture.GetTemporary(_mask.width, _mask.height, 0, RenderTextureFormat.ARGBHalf);
        Graphics.Blit(_mask, rt);
        Graphics.Blit(rt, _mask, _mat);
        RenderTexture.ReleaseTemporary(rt);

    }
    private void LateUpdate()
    {
        _oldPos = t.position;
    }

    private void OnGUI()
    {
        GUI.DrawTexture(new Rect(0, 0, 200, 200), _mask, ScaleMode.ScaleToFit);
    }
}
