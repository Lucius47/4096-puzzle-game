using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;
using UnityEngine.UI;

public class BlockInput : MonoBehaviour
{
    [SerializeField] private GraphicRaycaster uiRaycaster;

    private PointerEventData _clickData;
    private List<RaycastResult> _clickResults;

    private Block _tempBlock;
    private Block _tempBlock2;
    
    private void Awake()
    {
        _clickData = new PointerEventData(EventSystem.current);
        _clickResults = new List<RaycastResult>();
    }

    private void Update()
    {
        if (Mouse.current.leftButton.wasPressedThisFrame)
        {
            _clickData.position = Mouse.current.position.ReadValue();
            _clickResults.Clear();
            
            uiRaycaster.Raycast(_clickData, _clickResults);

            foreach (var raycastResult in _clickResults)
            {
                GameObject uiElement = raycastResult.gameObject;
                if (uiElement.TryGetComponent(out _tempBlock))
                {
                    MoveHandler.Instance.BeginMove(_tempBlock);
                }
            }
        }
        
        if (Mouse.current.leftButton.wasReleasedThisFrame)
        {
            MoveHandler.Instance.EndMove();
            _tempBlock = null;
            _tempBlock2 = null;
        }
        
        if (Mouse.current.leftButton.isPressed)
        {
            _clickData.position = Mouse.current.position.ReadValue();
            _clickResults.Clear();
            
            uiRaycaster.Raycast(_clickData, _clickResults);
        
            foreach (var raycastResult in _clickResults)
            {
                GameObject uiElement = raycastResult.gameObject;
                uiElement.TryGetComponent(out _tempBlock2);
                if (_tempBlock2 == _tempBlock || !_tempBlock) return;
                
                if (uiElement.TryGetComponent<Block>(out var block))
                {
                    MoveHandler.Instance.AddBlockToMove(block);
                }
            }
        }
    }
}
