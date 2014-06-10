using Gtk;

public void on_SendButton_clicked(Button source){
    source.label = "Test";
    stdout.printf ("Click event!");
}

int main (string[] args) {
    Gtk.init(ref args);
    
    try{
        var builder = new Builder ();
        builder.add_from_file ("main.ui");
        builder.connect_signals (null);
        var window = builder.get_object("EmailDialog") as Dialog;
        window.show_all();
        Gtk.main ();
    } catch (Error e) {
        stderr.printf ("Could not load UI: %s\n", e.message);
        return 1;
    }
    return 0;
}
