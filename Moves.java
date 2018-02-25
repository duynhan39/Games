import com.sun.org.apache.xpath.internal.operations.Bool;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

public class Moves {
    private int healthPoint = 0;
    private String description = new String();
    private HashMap<String, Integer> effectsList= new HashMap<>();
    private ArrayList<String> openRooms = new ArrayList<>();

    Moves(Moves move) {
        this.healthPoint = move.healthPoint;
        this.description = new String(move.description);
        this.effectsList = new HashMap<>(move.effectsList);
        this.openRooms = new ArrayList<>(move.openRooms);
    }

    Moves() {}

    public void setHealthPoint(int points) {
        this.healthPoint = points;
    }

    public Integer getHealthPoint() {
        return this.healthPoint;
    }

    public void setDescription(String st) {
        this.description = new String(st);
    }

    public String getDescription() {
        return this.description;
    }

    public void addEffectsList(String object, Integer state) {
        this.effectsList.put(object, state);
    }

    public HashMap<String, Integer> getEffectsList() {
        return effectsList;
    }

    public void addOpenRooms(String room) {
        this.openRooms.add(room);
    }

    public ArrayList<String> getOpenRooms() {
        return openRooms;
    }

}