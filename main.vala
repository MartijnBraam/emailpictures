using Gtk;

const string GETTEXT_PACKAGE = "main";

public void on_SendButton_clicked(Button source){
    Process.spawn_command_line_async("gedit");
    Gtk.main_quit();
}

public void on_CancelButton_clicked(Button source){
    Gtk.main_quit();
}

int main (string[] args) {
    Gtk.init(ref args);

    Intl.setlocale(LocaleCategory.MESSAGES, "");
    Intl.textdomain(GETTEXT_PACKAGE);
    Intl.bind_textdomain_codeset(GETTEXT_PACKAGE, "utf-8");
    Intl.bindtextdomain(GETTEXT_PACKAGE, "./locale");

    try{
        var builder = new Builder ();
        builder.add_from_file ("main.ui");
        builder.connect_signals (null);
        var window = builder.get_object("EmailDialog") as Dialog;
        window.show_all();

        var countLabel = builder.get_object("CountLabel") as Label;
        countLabel.label = _("You selected %d images").printf( args.length - 1 );

        Gtk.main ();
    } catch (Error e) {
        stderr.printf ("Could not load UI: %s\n", e.message);
        return 1;
    }
    return 0;
}
