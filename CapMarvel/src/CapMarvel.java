import java.io.*;
import java.util.*;

public class CapMarvel extends Object{
    private HashMap<String, Rooms> worldMap = new HashMap<>();
    private HashMap<String, Object> allTheItems = new HashMap<>();
    private ArrayList<Characters> roles = new ArrayList<>();
    private int player = 0;
    private HashMap<String, Moves> skillsList = new HashMap<>();
    private ArrayList<String> history = new ArrayList<>();
    private Boolean firstTranform = true;

    private ArrayList<String> compassDir = new ArrayList<>(Arrays.asList("n", "s", "e", "w", "se", "sw", "ne", "nw", "thegate"));

    public void Run() {
        while(true) {
            StringBuilder command = new StringBuilder(), target = new StringBuilder();
            readInput(command, target);
            makeMove(command, target);
            if (roles.get(player).getCurHealth() <= 0) {
                printDeadMessage(firstTranform);
                break;
            }
            if(allTheItems.get("octopus").getState()==1) {
                printWinMessage();
                break;
            }
        }
    }

    public void createWorld(String name) throws IOException {

        Characters role = new Characters();
        role.kidMode(name);
        roles.add(role);

        role = new Characters();
        role.shazamMode();
        roles.add(role);

        readAllItems("src/ObjectsDescription.txt");
        readAllRooms("src/RoomsDescription.txt");
    }

    private void readAllItems(String fileName) throws IOException {
        File file = new File(fileName);
        BufferedReader br = new BufferedReader(new FileReader(file));

        // Skip first 12 lines of input frame
        for(int i=0; i<12; i++) {
            String st = br.readLine();
        }

        Object newOb = new Object();
        newOb.readObject(br);
        while (!Objects.equals("null", newOb.getName())) {
            allTheItems.put(newOb.getName(), new Object(newOb));
            newOb = new Object();
            newOb.readObject(br);
        }
    }

    private void readAllRooms(String fileName) throws IOException {
        File file = new File(fileName);
        BufferedReader br = new BufferedReader(new FileReader(file));

        // Skip first 7 lines of input frame
        for(int i=0; i<7; i++) {
            String st = br.readLine();
        }

        Rooms newRoom = new Rooms();
        newRoom.readRoom(br);
        while (!Objects.equals("null", newRoom.getName())) {
            worldMap.put(newRoom.getName(), new Rooms(newRoom));
            newRoom = new Rooms();
            newRoom.readRoom(br);
        }
    }

    private String convertNoun(String noun) {

        // Convert Object/Target
        switch (noun.toLowerCase()) {
            case "north":
                noun = "n";
                break;
            case "south":
                noun = "s";
                break;
            case "east":
                noun = "e";
                break;
            case "west":
                noun = "w";
                break;
            case "southwest":
                noun = "sw";
                break;
            case "southeast":
                noun = "se";
                break;
            case "northwest":
                noun = "nw";
                break;
            case "mortheasr":
                noun = "ne";
                break;
            case "snake":
                noun = "jormungandr";
                break;
            case "serpent":
                noun = "jormungandr";
                break;
            case "world serpent":
                noun = "jormungandr";
                break;
            case "moon":
                noun = "silver moon";
                break;
            case "tree":
                noun = "yggdrasil";
                break;
            case "world tree":
                noun = "yggdrasil";
                break;
            case "yggdrasil tree":
                noun = "yggdrasil";
                break;
            case "sun":
                noun = "golden sun";
                break;
            case "gate":
                noun = "thegate";
                break;
            case "the gate":
                noun = "thegate";
                break;
            case "crack":
                noun = "thegate";
                break;
            case "book":
                noun = "book of thoth";
                break;
            case "pillar":
                noun = "moon pillar";
                break;
            case "pillar of moon":
                noun = "moon pillar";
                break;
            case "tales":
                noun = "tales of time";
                break;
            case "artemis":
                noun = "room artemis";
                break;
            case "moon room":
                noun = "room atermis";
                break;
            case "room moon":
                noun = "room atermis";
                break;
            case "bridge":
                noun = "bifrost bridge";
                break;
            case "bifrost":
                noun = "bifrost bridge";
                break;
            case "island":
                noun = "asgard";
                break;
            case "floating island":
                noun = "asgard";
                break;
            case "flying island":
                noun = "asgard";
                break;
            case "tree room":
                noun = "room yggdrasil";
                break;
            case "room tree":
                noun = "room yggdrasil";
                break;
            case "my pocket":
                noun = "pocket";
                break;
            case "health":
                noun = "status";
                break;
            case "monster":
                noun = "octopus";
                break;
            case "monster octopus":
                noun = "octopus";
                break;
            case "octopus monster":
                noun = "octopus";
                break;
            case "key":
                noun = "key of janus";
                break;
            case "smash":
                noun = "hit";
                break;
            case "stone":
                noun = "stone baetylus";
                break;
            case "rock":
                noun = "stone baetylus";
                break;
            default:
                noun = noun.toLowerCase();
                break;
        }
        return noun;
    }

    private String convertVerb(String verb) {

        if(Objects.equals("shazam", verb.toLowerCase())) {
            return verb;
        }
        // Convert Verb
        switch (verb.toLowerCase()) {
            case "hear":
                verb = "listen";
                break;
            case "examine":
                verb = "check";
                break;
            case "exam":
                verb = "check";
                break;
            case "chck":
                verb = "check";
                break;
            case "acquire":
                verb = "get";
                break;
            case "taste":
                verb = "try";
                break;
            case "touch":
                verb = "try";
                break;
            case "enter":
                verb = "go";
                break;
            default:
                verb = verb.toLowerCase();
                break;
        }
        return verb;
    }

    private void readInput(StringBuilder moveName, StringBuilder target) {
        String verb = new String(), word = new String(), line = new String();

        Scanner sc = new Scanner(System.in);
        line = sc.nextLine();
        String[] tokens = line.split(" ");

        // Get verb
        verb = tokens[0];
        String noun = new String();
        // End get verb

        // Get target
        ArrayList<String> notNeeded = new ArrayList<>(Arrays.asList("the", "a", "an", "to", "into"));

        for(int i = 1; i < tokens.length; i++) {
            if (!notNeeded.contains(tokens[i])) {
                word+=new String(tokens[i])+" ";
            }
        }
        if(word.length()>0)
            word = word.substring(0,word.length()-1);
        // End get target

        moveName.delete(0, moveName.length()).append(convertVerb(verb));
        target.delete(0, target.length()).append(convertNoun(word));
    }

    private void addItemsToRoom(String source) {
        for(String eachItem:allTheItems.get(source).getActivateList()) {
            worldMap.get(roles.get(player).getLocation()).addObjectOfRoom(eachItem);
        }
        allTheItems.get(source).removeActivateItems();
    }

    private void deactivateRoomItems(String roomName) {
        for(String each:allTheItems.keySet()) {
            allTheItems.get(each).deactivateOb();
        }
    }

    private void activateRoomItems(String roomName) {
        for(String each:worldMap.get(roomName).getObjectsOfRoom()) {
            allTheItems.get(each).activateOb();
        }
    }

    private void activatePocketItems(String roomName) {
        for(String each:worldMap.get(roomName).getPocketUse()) {
            if(roles.get(player).getPocket().contains(each))
                allTheItems.get(each).activateOb();
        }
    }

    private void deactivatePocketItems(String roomName) {
        for(String each:worldMap.get(roomName).getPocketUse()) {
            if(roles.get(player).getPocket().contains(each))
                allTheItems.get(each).activateOb();
        }
    }

    // Move character's location and activate items
    public void changeRoom(String targetRoom) {
        if(roles.get(player).getLocation() != null) {
            deactivateRoomItems(roles.get(player).getLocation());
            deactivatePocketItems(roles.get(player).getLocation());
        }
        roles.get(player).goTo(targetRoom);

        activateRoomItems(targetRoom);
        activatePocketItems(targetRoom);

        worldMap.get(targetRoom).describe();
        if(worldMap.get(targetRoom).getState()==0)
            worldMap.get(targetRoom).beenHere();
    }

    // Do Effects: and Open:
    private void implementEffect(String object, String action) {
        if(allTheItems.get(object).getActionsList().containsKey(action)) {

            //Activate all item
            Moves effect = new Moves(allTheItems.get(object).getActionsList().get(action));

            // Trigger items
            for(String target:effect.getEffectsList().keySet())
                allTheItems.get(target).setState(effect.getEffectsList().get(target));

            // Open Rooms
            for(String eachRoom : effect.getOpenRooms()) {
                worldMap.get(eachRoom).setActivated();

            }
        }
    }

    private void implementMove(String target, String moveName) {
        if (allTheItems.get(target).getActionsList().containsKey(moveName)) {
            printOut(allTheItems.get(target).getActionsList().get(moveName).getDescription());
            implementEffect(target, moveName);
            roles.get(player).addHealth(allTheItems.get(target).getActionsList().get(moveName).getHealthPoint());
        }
    }

    private void printNotFoundMessage(String st) {
        String message = new String();
        switch(st) {
            case "item":
                message = new String("I ain't see that around!");
                break;
            case "room":
                message = new String("I ain't know where is that");
                break;
            case "direction":
                message = new String("I can't go dat way!");
                break;
            case "pocket":
                message = new String("But I ain't have that!");
                break;
            case "not here":
                message = new String("No use!");
                break;
            case "sound":
                message = new String("There is the sound of the Universe, which is nothing, and pure energy!");
                break;
            case "cant use":
                message = new String("You can't just do that!");
                break;
            case "shout":
                message = new String("What are you doing? Whispering? Talk like a real man!");
                break;
            case "used":
                message = new String("You used it already! What else you want to do wiit it!");
                break;
            case "cant get":
                message = new String("You cant just take it!");
                break;
            default:
                message = new String("I ain't know what ya talking about");
                break;
        }
        System.out.println(message+"\n");
    }

    private void printDeadMessage(Boolean mode) {
        if(!mode)
            System.out.println("We didn't know that superhero can die?!?!!!\nHow could you manage to die that with all that power?!!");
        else
            System.out.println("Your health bar is drained, that means you're dead!");
        System.out.println("Apparently, we failed to estimate your incompetence!");
        System.out.println("Goodluck saving the world next time, " + roles.get(player).getName() + "!\nNext please!");
    }

    private void printWinMessage() {
        System.out.println("Oh well, the monster's dead! You won!\nWhat's there to brag about, with that kind of power I bet anyone could!\nTime to clean up guys!");
    }

    // Print out with format
    private void printOut(String des) {
        String[] tokens = des.split("  ");
        for(String eachToken:tokens) {
            System.out.println(eachToken);
        }
    }

    private void switchRole() {
        player+=1;
        player=player%2;
        System.out.println("Lightning strikes from the sky causing and explosion!!\nMy body change!");
        System.out.println("I am now "+roles.get(player).getName());
        firstTranform = false;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //// Handling ALL ACTIONS!!!
    public void makeMove(StringBuilder verb, StringBuilder noun){
        ArrayList<String> specialVerbs = new ArrayList<>(Arrays.asList("listen", "look", "get" ,"check", "use"));
        String moveName = new String(verb);
        String target = new String(noun);

        if(Objects.equals("SHAZAM", moveName.toUpperCase()) && allTheItems.get("stone baetylus").getState()==1) {
            if(!Objects.equals("SHAZAM", moveName)) {
                printNotFoundMessage("shout");
                return;
            } else {
                //SHAZAM
                Boolean first = firstTranform;
                switchRole();
                if(first) {
                    changeRoom("city");
                }
                return;
            }
        }

        // Moves without objects
        switch (moveName) {
            case "listen":
                printNotFoundMessage("sound");
                return;
            case "look":
                if(Objects.equals("", target))
                    worldMap.get(roles.get(player).getLocation()).describe();
                return;
            case "status":
                roles.get(player).curStatus();
                return;
            case "pocket":
                roles.get(player).inPocket();
                return;
            default:
                break;
        }
        // End moves without objects

        // Moves with objects
        if(!Objects.equals("", target)) {

            // Action go
            if(Objects.equals("go", moveName)) {

                if (compassDir.contains(target) && worldMap.get(roles.get(player).getLocation()).getPaths().containsKey(target)) {

                    String roomName = new String(worldMap.get(roles.get(player).getLocation()).getPaths().get(target));
                    if (!worldMap.get(roomName).isActivated()) {
                        printNotFoundMessage("direction");
                        return;
                    }
                    changeRoom(roomName);

                } else if (worldMap.keySet().contains(target) && worldMap.get(target).getState() > 0) {
                    changeRoom(target);

                } else {
                    printNotFoundMessage("room");
                }
                return;
            }
            // End action go

            // Check roles.get(player)
            if(Objects.equals("check", moveName)) {
                if(Objects.equals("status", target)) {
                    roles.get(player).curStatus();
                    return;
                }
                if(Objects.equals("pocket", target)) {
                    roles.get(player).inPocket();
                    return;
                }
            }

            // Item not exist or activated
            if (!allTheItems.keySet().contains(target)) {
                printNotFoundMessage("");
                return;
            }

            if (!allTheItems.get(target).isActivated()) {
                printNotFoundMessage("item");
                return;
            }
            // End Item not exist or activated

            // Other special moves
            switch (moveName) {
                case "check":
                    allTheItems.get(target).decribe();
                    for (String each : allTheItems.get(target).getActivateList())
                        worldMap.get(roles.get(player).getLocation()).addPocketUse(each);

                    addItemsToRoom(target);
                    activateRoomItems(roles.get(player).getLocation());
                    implementMove(target, moveName);
                    break;
                case "get":
                    if (allTheItems.get(target).isAcquirable()) {
                        roles.get(player).addItems(target);
                        implementMove(target, moveName);
                        System.out.println(roles.get(player).getName() + " puts " + allTheItems.get(target).printName() + " inside Pocket!");
                        worldMap.get(roles.get(player).getLocation()).removeItem(target);
                        //allTheItems.get(target).deactivateOb();
                    } else
                        implementMove(target, moveName);
                    if(!allTheItems.get(target).getActionsList().containsKey(moveName))
                        printNotFoundMessage("cant get");
                    break;
                case "use":
                    if (!roles.get(player).getPocket().contains(target)) {
                        printNotFoundMessage("pocket");
                        return;
                    } else {
                        if(allTheItems.get(target).isUsed()) {
                            printNotFoundMessage("used");
                            return;
                        } else if(allTheItems.get(target).isActivated()) {
                            implementMove(target, moveName);
                            allTheItems.get(target).archive();
                            roles.get(player).dropItem(target);
                        } else {
                            printNotFoundMessage("not here");
                            return;
                        }
                    }
                default:
                    break;
            }
            //// End special moves

            if(!specialVerbs.contains(moveName)) {
                implementMove(target, moveName);
                if(!allTheItems.get(target).getActionsList().containsKey(moveName)) {
                    printNotFoundMessage("");
                }
            }

            // Refresh Room
            deactivateRoomItems(roles.get(player).getLocation());
            activateRoomItems(roles.get(player).getLocation());
            activatePocketItems(roles.get(player).getLocation());

            return;
        }
        printNotFoundMessage("");
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}
