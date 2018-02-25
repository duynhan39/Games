import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

public class Characters {
    private String charName = new String();
    private int maxHealth = 0;
    private int curHealth = 0;
    private ArrayList<String> pocket = new ArrayList<>();
    private ArrayList<String> moveList = new ArrayList<>();
    private Boolean isAlive = true;

    private String location = null;

    Characters(String name, int Health) {
        this.charName = name;
        this.maxHealth = Health;
        this.curHealth = Health;
    }

    Characters() {}

    public String getName() {
        return this.charName;
    }

    public void addItems(String name) {
        this.pocket.add(name);
    }

    public void dropItem(String name) {
        this.pocket.remove(name);
    }

    public ArrayList<String> getPocket() {
        return pocket;
    }

    public void goTo(String destination) {
        this.location = destination;
    }

    public String getLocation() {
        return this.location;
    }

    public void addHealth(int amount) {
        this.curHealth+=amount;
        String st = null;
        if(amount>0) {
            if (amount < this.maxHealth - this.curHealth)
                System.out.println("You have gained " + amount + " health points!");
            else {
                System.out.println("Your health bar is full!");
                this.curHealth = this.maxHealth;
            }
        }
        if(amount<0 && amount>-1000)
            System.out.println("You have lost " + (-amount) + " health points!");
        System.out.println();
    }

    public int getCurHealth() {
        return this.curHealth;
    }

    public void curStatus() {
        String st = new String("------------------------------");
        System.out.println(charName);
        System.out.println("+ Health: "+ curHealth + "/" + maxHealth);
        System.out.println(st);
        for(int i=0; i<((curHealth*st.length())/maxHealth); i++) {
            System.out.print("/");
        }
        System.out.print("\n");
        System.out.println(st+"\n");
    }

    public void inPocket() {
        System.out.println("---------------------------------");
        if(this.pocket.size()==0)
            System.out.println(charName + " has nothing :((");
        else {
            System.out.println(charName + " has:");
            for (String each : pocket)
                System.out.println("- " + each);
        }
        System.out.println("---------------------------------\n");
    }

    public void kidMode(String userName) {
        this.charName = new String(userName);
        this.maxHealth = 100;
        this.curHealth = 100;
    }

    public void shazamMode() {
        new Characters();
        this.charName = new String("Shazam");
        this.maxHealth = 10000;
        this.curHealth = 10000;
    }

}
