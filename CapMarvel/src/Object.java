import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

public class Object {
    private String objectName = new String();
    private Boolean acquirable = false;
    private Boolean activated = false;
    private Integer state = 0;
    private ArrayList<String> description = new ArrayList<>();
    private ArrayList<String> activateList = new ArrayList<>();
    private Boolean used = false;
    private HashMap<String, Moves> actionsList = new HashMap<>();

    Object(String name, Boolean ableToAcquire, Boolean activated, ArrayList<String> des) {
        this.objectName = name;
        this.acquirable = ableToAcquire;
        this.activated = activated;
        this.description = des;
    }

    Object() {}

    Object(Object original) {
        this.objectName = new String(original.objectName);
        this.acquirable = original.acquirable;
        this.activated = original.activated;
        this.state = original.state;
        this.description = new ArrayList<>(original.description);
        this.activateList = new ArrayList<>(original.activateList);
        this.used = original.used;
        this.actionsList = new HashMap<>(original.actionsList);
    }

    public Integer getState() {
        return state;
    }

    public void activateOb() {
        this.activated = true;
    }

    public void deactivateOb() {
        this.activated = false;
    }

    public Boolean isActivated() {
        return this.activated;
    }

    public Boolean isAcquirable() {
        return this.acquirable;
    }

    public void removeActivateItems() {
        this.activateList = new ArrayList<>();
    }

    public String printName() {
        String name = new String();
        String[] tokens = this.objectName.split(" ");
        name = new String();
        for(String each:tokens) {
            name+=each.substring(0,1).toUpperCase()+each.substring(1)+" ";
        }
        name = name.substring(0, name.length()-1);
        return name;
    }

    public void decribe(int i) {
        System.out.println(printName());
        for(int _=0; _<printName().length(); _++)
            System.out.print("-");
        System.out.println();

        String[] descrip = this.description.get(i).split("  ");
        for(String eachSen:descrip) {
            System.out.println(eachSen);
        }
        System.out.println();
    }

    public void decribe() {
        decribe(state);
    }

    public void setState(int i) {
        this.state = i;
    }
    
    public String getName() {
        return objectName;
    }

    private void setObjectName(String name) {
        this.objectName = new String(name);
    }

    public HashMap<String, Moves> getActionsList() {
        return actionsList;
    }

    public ArrayList<String> getActivateList() {
        return activateList;
    }

    public void archive() {
        this.used = true;
    }

    public Boolean isUsed() {
        return used;
    }

    public Object readObject(BufferedReader br) throws IOException {
        String st;
        if((st = br.readLine()) != null) {
            // Skip empty lines
            while(Objects.equals("", st)) {
                st = br.readLine();
            }

            // Break if end of input
            if(Objects.equals(null, st)) {
                this.objectName = new String("null");
                return this;
            }

            // Name:
            int stIndex = 6;
            this.setObjectName(st.substring(stIndex));

            st = br.readLine();

            // Description:
            st = br.readLine();
            while(!Objects.equals("Actions:", st)) {
                this.description.add(new String(st));
                st = br.readLine();
            }
            // st="Action:"

            // Actions
            st = br.readLine();
            while(st.length()<11 || !Objects.equals("Acquirable:", st.substring(0, 11)) && !Objects.equals("Activate List:", st)) {
                Moves curMove = new Moves();

                String descrip = br.readLine();
                String moveName = new String(st);
                curMove.setHealthPoint(new Integer(br.readLine()));
//                this.actionsList.put(new String(st), curMove);
//                this.healthPoint.put(new String(st), new Integer(br.readLine()));
                curMove.setDescription(descrip);
                st = br.readLine();

                // Effect: Optional
                while(st.length()>8 && Objects.equals("Effect:", st.substring(0, 7))) {
                    String[] tokens = st.split(" ");
                    curMove.addEffectsList(st.substring(tokens[1].length()+9), new Integer(tokens[1]));
                    st = br.readLine();
                }

                // Open: Optional
                while(st.length()>6 && Objects.equals("Open:", st.substring(0, 5))) {
                    curMove.addOpenRooms(st.substring(6));
                    st = br.readLine();
                }

                this.actionsList.put(new String(moveName), curMove);
            }

            // Activate List
            if(Objects.equals("Activate List:", st)) {
                st = br.readLine();
                while(st.length()<11 || !Objects.equals("Acquirable:", st.substring(0, 11))) {
                    this.activateList.add(new String(st));
                    st = br.readLine();
                }
            }

            // Acquirable:
            stIndex = 12;
            if(Objects.equals("yes", st.substring(stIndex)))
                this.acquirable = true;
        } else
            this.objectName = new String("null");
        return this;
    }
}
