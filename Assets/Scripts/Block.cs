using TMPro;
using UnityEngine;

public class Block : MonoBehaviour
{
    public int number;
    public Vector2 gridPosition;

    private TextMeshProUGUI _numberText;

    private void Awake()
    {
        _numberText = GetComponentInChildren<TextMeshProUGUI>();
        _numberText.text = number.ToString();
    }
}
