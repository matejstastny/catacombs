package catacombs;

import org.jline.terminal.Terminal;
import org.jline.terminal.TerminalBuilder;
import org.jline.utils.NonBlockingReader;

import catacombs.objects.GameMap;
import catacombs.util.TerminalUtil;

public class App {

    private GameMap map;

    public static void main(String[] args) {
        new App();
    }

    public App() {
        map = new GameMap();
        gameLoop();
    }

    public void gameLoop() {
        try (Terminal terminal = TerminalBuilder.builder().system(true).jansi(false).build()) {
            terminal.enterRawMode();
            NonBlockingReader reader = terminal.reader();

            while (true) {
                TerminalUtil.clearScreen();
                map.render();
                System.out.println("Use arrow keys to move. Press 'q' to quit.");

                int ch = reader.read();
                if (ch == 'q') {
                    break;
                }
                if (ch == 27) { // ESC - start of arrow key sequence
                    int next = reader.read();
                    if (next == '[') {
                        int arrow = reader.read();
                        switch (arrow) {
                            case 'A' -> map.movePlayer(0, -1); // Up
                            case 'B' -> map.movePlayer(0, 1); // Down
                            case 'C' -> map.movePlayer(1, 0); // Right
                            case 'D' -> map.movePlayer(-1, 0); // Left
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
