using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class MoveHandler : MonoBehaviour
{
    public static MoveHandler Instance;
    private LineRenderer _lineRenderer;

    private List<Block> _selectedBlocks;
    private bool _duringMove;

    public List<Slot> allSlots;

    [SerializeField] private Block blockPrefab;
    [SerializeField] private Transform blocksParent;

    [SerializeField] private int[] possibleBlockValues;
    [SerializeField] private Slot[] spawningSlots;

    public static UnityAction OnMoveEnded;

    private void Awake()
    {
        Instance = this;
        _lineRenderer = GetComponent<LineRenderer>();
        _lineRenderer.positionCount = 0;
        _lineRenderer.enabled = false;
        _selectedBlocks = new List<Block>();
        _duringMove = false;
    }

    private void Start()
    {
        SetCoordsForAllSlots();
        SpawnFirstBlocks();
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

    private void SpawnFirstBlocks()
    {
        foreach (var slot in allSlots)
        {
            var block = Instantiate(blockPrefab, blocksParent);
            block.gridPosition = slot.gridCoordinate;
            block.number = possibleBlockValues[Random.Range(0, possibleBlockValues.Length)];
        }
    }
    
    private void SpawnNewBlocks()
    {
        foreach (var slot in spawningSlots)
        {
            if (!slot.isOccupied)
            {
                var block = Instantiate(blockPrefab, blocksParent);
                block.gridPosition = slot.gridCoordinate;
                block.number = possibleBlockValues[Random.Range(0, possibleBlockValues.Length)];
            }
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

        var prevBlockPos = _selectedBlocks[^1].gridPosition;
        var magnitude = (prevBlockPos - block.gridPosition).magnitude;

        if (magnitude < 1.5 && magnitude > 0.9) // only connect with neighbouring blocks 
        {
            if (_selectedBlocks[^1].number == block.number) // only connect with block of appropriate number
            {
                _selectedBlocks.Add(block);
        
                _lineRenderer.positionCount++;
                _lineRenderer.SetPosition(_lineRenderer.positionCount - 2, block.transform.position);
            }
        }
    }

    public void EndMove()
    {
        OnMoveEnded.Invoke();
        
        _duringMove = false;
        _selectedBlocks.Clear();
        _lineRenderer.positionCount = 0;
        _lineRenderer.enabled = false;
    }

    public Slot SetBlockToSlot(Vector2 coord)
    {
        foreach (var slot in allSlots)
        {
            if (slot.gridCoordinate == coord)
            {
                slot.isOccupied = true;
                return slot;
            }
        }

        return null;
    }

    
    [ContextMenu("Set Coords")]
    public void SetCoordsForAllSlots()
    {
        int index = 0;
        
        for (int row = 1; row < 9; row++)
        {
            for (int col = 1; col < 6; col++)
            {
                allSlots[index].gridCoordinate.x = col;
                allSlots[index].gridCoordinate.y = row;
                allSlots[index].SetText();
                index++;
            }
        }
    }
}
