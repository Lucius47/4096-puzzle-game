using TMPro;
using UnityEngine;

[ExecuteInEditMode]
public class Slot : MonoBehaviour
{
    [HideInInspector] public Vector2 gridCoordinate;
    public bool isOccupied;

    public void SetText()
    {
        GetComponentInChildren<TextMeshProUGUI>().text = gridCoordinate.x + ", " + gridCoordinate.y;
    }
}
