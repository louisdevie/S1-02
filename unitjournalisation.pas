unit unitJournalisation;

interface

    procedure initJournal;

    procedure debug(message: String);

implementation

    var
        fichierjournal: Text;

    procedure initJournal;
    begin
        assignFile(fichierjournal, 'journal.txt');
    end;

    procedure debug(message: String);
    begin                              
        append(fichierjournal);
        writeln(fichierjournal, message);
        closeFile(fichierjournal);
    end;

end.

