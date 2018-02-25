import java.io.*;
import java.util.Scanner;

public class Game {

    public static void main(String[] args) {
        CapMarvel game = new CapMarvel();
        String playerName;
        try {
            playerName = new String(intro());
            game.createWorld(playerName);
            game.changeRoom("tales of time");
            game.Run();
        } catch (IOException e) {
            System.out.println("File not found!");
        }
    }

    public static String intro() throws IOException {
        File file = new File("src/intro.txt");
        BufferedReader br = new BufferedReader(new FileReader(file));
        String st = null;
        while((st = br.readLine()) != null) {
            System.out.println(st);
        }
        System.out.print("Fill your name in and let's get you some power: ");

        Scanner sc = new Scanner(System.in);
        st = sc.nextLine();
        String band = new String("============================================================================================");
        while(st.length()>band.length()) {
            System.out.println("You should ask your mom for a shorter name, my friend! Or make one, like right now!");
            System.out.println("Tell me what it is when you're ready!");
            st = sc.nextLine();
        }
        int spaces = (band.length() - st.length())/2;
        System.out.println(band);
        for(int _=0; _<spaces; _++)
            System.out.print(" ");
        System.out.print(st.toUpperCase());
        for(int _=0; _<spaces; _++)
            System.out.print(" ");
        System.out.println("\n"+band);
        System.out.println("Let's get you a cape and put you in some challenges!");
        System.out.println("Go find your power boi!\n");
        return st;
    }
}
