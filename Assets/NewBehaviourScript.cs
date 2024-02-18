using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NewBehaviourScript : MonoBehaviour
{
    public Material material;
    private Vector4 _trans;
    public Camera c;
    private Vector4 Trans
    {
        get
        {
            return _trans;
        }
        set
        {
            material?.SetVector("_Trans", value);
            _trans = value;
        }
    }
    private Vector2 MP
    {
        get
        {
            var wp = (Vector2)c.ScreenToWorldPoint(Input.mousePosition);
            var sp = (wp - new Vector2(10, 10)) / 20;
            var t = Trans;
            return Vector2.Scale(new Vector2(t.z, t.w), new Vector2(t.x, t.y) + sp);
        }
    }
    private bool md = false;
    private Vector2 pos;
    private void Start()
    {
        _trans = material.GetVector("_Trans");
    }
    void Update()
    {
        if (Input.mouseScrollDelta.y != 0)
        {
            var mp = MP;
            var s = 1 - Input.mouseScrollDelta.y * .05f;
            var t = Trans;
            t.z *= s; t.w *= s;
            Trans = t;
            t = Trans;
            mp -= MP;
            t.x -= mp.x;
            t.y -= mp.y;
            Trans = t;
        }
        if (Input.GetMouseButtonDown(0))
        {
            md = true;
            pos = MP;
        }
        if (Input.GetMouseButtonUp(0)) { md = false; }
        if (md)
        {
            var d = pos - MP;
            var t = Trans;
            t.x += d.x;
            t.y += d.y;
            Trans = t;
            pos = MP;
        }
    }
}
