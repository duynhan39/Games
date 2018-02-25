import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;

public class Rooms {
    private String roomName = new String();
    private int state = 0;
    private Boolean activated = false;
    private ArrayList<String> description = new ArrayList<>();
    private ArrayList<String> objectsOfRoom = new ArrayList<>();
    private ArrayList<String> pocketUse = new ArrayList<>();
    private HashMap<String, String> paths = new HashMap<>();


    Rooms(String name) {
        this.roomName = new String(name);
    }

    Rooms() {}

    Rooms(Rooms oriRoom) {
        this.roomName = new String(oriRoom.roomName);
        this.state = oriRoom.state;
        this.activated = oriRoom.activated;
        this.description = new ArrayList<>(oriRoom.description);
        this.objectsOfRoom = new ArrayList<>(oriRoom.objectsOfRoom);
        this.pocketUse = new ArrayList<>(oriRoom.pocketUse);
        this.paths = new HashMap<>(oriRoom.paths);
    }

    public void beenHere() {
        this.state = 1;
    }

    public int getState() {
        return new Integer(state);
    }

    private void setName(String name) {
        this.roomName = new String(name);
    }

    public String getName() {
        return this.roomName;
    }

    public void setActivated() {
        this.activated = true;
    }

    public Boolean isActivated() {
        return this.activated;
    }


    public HashMap<String, String> getPaths() {
        return paths;
    }

    public ArrayList<String> getObjectsOfRoom() {
        return objectsOfRoom;
    }

    public void addObjectOfRoom(String item) {
        this.objectsOfRoom.add(new String(item));
    }

    public ArrayList<String> getPocketUse() {
        return pocketUse;
    }

    public void describe() {
        String[] tokens = this.roomName.split(" ");
        String name = new String();
        for(String each:tokens) {
            name+=each.substring(0,1).toUpperCase()+each.substring(1)+" ";
        }
        name = name.substring(0, name.length()-1);
        System.out.println("-------------------------\n"+name+"\n-------------------------");

        String[] descrip = this.description.get(state).split("  ");
        for(String eachSen:descrip) {
            System.out.println(eachSen);
        }
        System.out.println();
    }

    public void addPocketUse(String item) {
        this.pocketUse.add(new String(item));
    }

    public void removeItem(String item) {
        this.objectsOfRoom.remove(item);
    }

//    public void setState(int i) {
//        this.state = new Integer(i);
//    }

    public Rooms readRoom(BufferedReader br) throws IOException {
        String st;
        if((st = br.readLine()) != null) {

            // Skip empty lines
            while(Objects.equals("", st)) {
                st = br.readLine();
            }

            // Break if hit end of file
            if(Objects.equals(null, st)) {
                this.roomName = new String("null");
                return this;
            }

            // Name
            int stIndex = 6;
            this.setName(st.substring(stIndex));
            st = br.readLine();

            // Activated
            if(Objects.equals("Activated", st)) {
                activated = true;
                st = br.readLine();
            }

            // Description
            st = br.readLine();
            this.description.add(st);

            st = br.readLine();
            st = br.readLine();
            this.description.add(st);

            // Hidden Form: Optional
            st = br.readLine();
            if(Objects.equals("Hidden Form:", st)) {
                while(true) {
                    st = br.readLine();
                    if(Objects.equals("Items List:", st) || Objects.equals("Paths:", st))
                        break;
                    this.description.add(st.substring(stIndex));
                }
            }

            // Items List: Optional
            if(Objects.equals("Items List:", st)) {
                while((st = br.readLine()) != null) {
                    if(Objects.equals("", st) || Objects.equals("Paths:", st))
                        break;
                    objectsOfRoom.add(new String(st));
                }
            }

            // Paths:
            if(Objects.equals("Paths:", st)) {
                while((st = br.readLine()) != null) {
                    if(Objects.equals("", st))
                        break;
                    String[] tokens = st.split(" ");
                    paths.put(tokens[0].toLowerCase(), st.substring(tokens[0].length()+1));
                }
            }
        } else
            this.roomName = new String("null");
        return this;
    }
}
