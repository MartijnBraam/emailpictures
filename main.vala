using Gtk;

const string GETTEXT_PACKAGE = "main";

public void on_SendButton_clicked(Button source){
    var subject = _("Message with images");
    var body = _("Hello, \n\nHere are some images");
    var mailprog = "thunderbird";
    var command = @"$mailprog -compose \"subject='$subject',body='$body'\"";
    Process.spawn_command_line_async(command);
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
        countLabel.label = _("You selected %d images\n").printf( args.length - 1 );

        Gdk.Pixbuf[] images = new Gdk.Pixbuf[args.length - 1];
        for (int i = 1; i < args.length; i++){
            images[i] = new Gdk.Pixbuf.from_file(args[i]);
            File file = File.new_for_path(args[i]);
            FileInfo file_info = file.query_info("standard::size", FileQueryInfoFlags.NONE);
            int64 file_size = file_info.get_size();
            stdout.printf("Loaded %s: %" + uint64.FORMAT_MODIFIER + "d bytes\n", args[i], file_size);
        }

        Gtk.main ();
    } catch (Error e) {
        stderr.printf ("Could not load UI: %s\n", e.message);
        return 1;
    }
    return 0;
}
