using System;
using TMPro;
using UnityEngine;

public class Block : MonoBehaviour
{
    public int number;
    public Vector2 gridPosition;

    private TextMeshProUGUI _numberText;
    private Slot _currentSlot;

    private void Awake()
    {
        _numberText = GetComponentInChildren<TextMeshProUGUI>();
    }

    private void OnEnable()
    {
        MoveHandler.OnMoveEnded += OnMoveEnded;
    }
    
    private void OnDisable()
    {
        MoveHandler.OnMoveEnded -= OnMoveEnded;
    }

    private void Start()
    {
        _currentSlot = MoveHandler.Instance.SetBlockToSlot(gridPosition);
        _numberText.text = number.ToString();
    }

    private void Update()
    {
        transform.position = Vector2.Lerp(transform.position, 
            _currentSlot.transform.position, Time.deltaTime * 50);
    }
    
    private void OnMoveEnded()
    {
        
    }
}
