using System;
using System.Collections.Generic;
using UnityEngine;

public class MoveHandler : MonoBehaviour
{
    public static MoveHandler Instance;
    private LineRenderer _lineRenderer;

    private List<Block> _selectedBlocks;
    private bool _duringMove;

    private void Awake()
    {
        Instance = this;
        _lineRenderer = GetComponent<LineRenderer>();
        _lineRenderer.positionCount = 0;
        _lineRenderer.enabled = false;
        _selectedBlocks = new List<Block>();
        _duringMove = false;
    }

    private void Update()
    {
        if (_lineRenderer.enabled)
        {
            var mousePos = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            mousePos.z = 0;
            _lineRenderer.SetPosition(_lineRenderer.positionCount - 1, mousePos);
        }
    }

    public void BeginMove(Block block)
    {
        if (_selectedBlocks.Contains(block)) return;
        _selectedBlocks.Add(block);
        
        _lineRenderer.enabled = true;
        _duringMove = true;
        _lineRenderer.positionCount = 2;
        _lineRenderer.SetPosition(0, block.transform.position);
    }

    public void AddBlockToMove(Block block)
    {
        if (!_duringMove) return;
        
        if (_selectedBlocks.Contains(block)) return;
        _selectedBlocks.Add(block);
        
        _lineRenderer.positionCount++;
        _lineRenderer.SetPosition(_lineRenderer.positionCount - 2, block.transform.position);
    }

    public void EndMove()
    {
        _duringMove = false;
        _selectedBlocks.Clear();
        _lineRenderer.positionCount = 0;
        _lineRenderer.enabled = false;
    }
}
