{
Unité de gestion des recettes
Les recettes sont placées dans une liste doublement chaînée circulaire,
   directement dans l'ordre.
}
unit unitListeRecettes;

interface
    uses unitPersonnage; // pour les types debonus

    type
        TypeRecette = record // représente une recette
            nom: String;
            effet: Bonus;
        end;


    // le plus long nom de recette
    function longueurMaxNomRecette: Integer;

    // le nombre total de pages des recettes
    function nombrePagesRecettes: Integer;


    // initialiser l'unité
    procedure initRecettes;

    // opérations à la fin du chargement
    procedure recettesChargees;


    // insère une recette dans la liste
    procedure insererRecette(recette: TypeRecette);


    // libère toutes les recettes de la mémoire
    procedure effacerRecettes;


    // parcours les recettes dans l'ordre alphabétique
    procedure triAlphaRecettes;

    // parcours les recettes par bonus
    procedure triBonusRecettes;

    // revient à la première page
    procedure premierePageRecettes;

    // passe à la page suivante
    procedure pageSuivanteRecettes;

    // passe à la page précédente
    procedure pagePrecedenteRecettes;

    // le numéro de la page actuelle
    function pageCouranteRecettes: Integer;

    // le nombre de recettes sur la page actuelle
    // (la dernière page peut contenir moins d'éléments si le nombre de recettes
    //    n'est pas un multiple de la taille d'une page)
    function taillePageRecettes: Integer;

    // renvoie une recette de la page actuelle (<numero> doit être entre 0
    //    inclus et <taillePageRecettes> exclu)
    function lireRecette(numero: Integer): TypeRecette;


implementation

    type
        _PtrCelluleRecette = ^_CelluleRecette;

        _CelluleRecette = record
            valeur: TypeRecette;
            precedantOrdreAlpha,
            suivantOrdreAlpha,
            precedantOrdreBonus,
            suivantOrdreBonus: _PtrCelluleRecette;
        end;

        _ModeTri = (ALPHABETIQUE, PARBONUS);

    // nombre de recettes par page
    const TAILLE_PAGE_RECETTES = 13;

    var
        _premiereRecetteAlpha, // ancres vers la première page
        _premiereRecetteBonus,
        _curseurPage: _PtrCelluleRecette; // pointe vers la première recette de la page en cours
        _modeTriUtilise: _ModeTri;
        _pageCourante, // numéro de la page courante
        _dernierePage, // numéro de la dernière page
        _tailleDernierePage, // taille de la dernière page
        _nombreDeRecettes, // nombre total de recettes
        _longueurMax : Integer; // longueur du nom de recette le plus long

    // initialisations des variables
    procedure initRecettes;
    begin
        _premiereRecetteAlpha := NIL;   
        _premiereRecetteBonus := NIL;
        _curseurPage := NIL;
        _curseurRecette := NIL;
        _nombreDeRecettes := 0;
        _dernierePage := 0;
        _tailleDernierePage := 0;
        _longueurMax := 0;
    end;


    function taillePageRecettes: Integer;
    begin
        if _pageCourante = _dernierePage then
            taillePageRecettes := _tailleDernierePage
        else
            taillePageRecettes := TAILLE_PAGE_RECETTES;
    end;

    // renvoie VRAI si <str1> est après <str2> dans l'ordre alphabétique, FAUX sinon
    function _estApresOrdreAlpha(str1, str2: String): boolean;
    var
        i, tailleMin: Integer;
    begin
        i := 1;
        // s'arrêter à la taille de la plus petite des deux chaînes
        if length(str1) > length(str2) then
            tailleMin := length(str2)
        else
            tailleMin := length(str1);

        while true do
            // si <str1> est plus grand, il est considéré après
            if i > tailleMin then begin
                _estApresOrdreAlpha := length(str1) > length(str2);
                break;
            // avancer jusqu'à trouver un caractère différent
            end else if str1[i] = str2[i] then
                i += 1
            else begin
                _estApresOrdreAlpha := ord(str1[i]) > ord(str2[i]);
                break;
            end;
    end;

    // renvoie VRAI si le bonus <eff1> vient après <eff2>, FAUX sinon
    function _estApresOrdreBonus(eff1, eff2: Bonus): boolean;
    begin
        _estApresOrdreBonus := ord(eff1) > ord(eff2);
    end;

    // insère <nouvelElement> dans la liste entre <elementAvant> et <elementApres>
    procedure _insererEntreAlpha(nouvelElement, elementAvant, elementApres: _PtrCelluleRecette);
    begin                                                   
        nouvelElement^.precedantOrdreAlpha := elementAvant;
        nouvelElement^.suivantOrdreAlpha := elementApres;      
        elementAvant^.suivantOrdreAlpha := nouvelElement;
        elementApres^.precedantOrdreAlpha := nouvelElement;
    end;

    // idem
    procedure _insererEntreBonus(nouvelElement, elementAvant, elementApres: _PtrCelluleRecette);
    begin
        nouvelElement^.precedantOrdreBonus := elementAvant;
        nouvelElement^.suivantOrdreBonus := elementApres;
        elementAvant^.suivantOrdreBonus := nouvelElement;
        elementApres^.precedantOrdreBonus := nouvelElement;
    end;

    procedure insererRecette(recette: TypeRecette);
    var
        curseurAlpha, curseurBonus, nouvelleRecette: _PtrCelluleRecette;
    begin
        _nombreDeRecettes += 1;

        if length(recette.nom) > _longueurMax then _longueurMax := length(recette.nom);

        // cas particulier : la liste est vide
        if _premiereRecetteAlpha = NIL then begin
            new(_premiereRecetteAlpha);
            _premiereRecetteBonus := _premiereRecetteAlpha;

            // la recette est la première et est sa propre suivante et précédente
            _premiereRecetteAlpha^.valeur := recette;
            _premiereRecetteAlpha^.precedantOrdreAlpha := _premiereRecetteAlpha;
            _premiereRecetteAlpha^.suivantOrdreAlpha := _premiereRecetteAlpha;
            _premiereRecetteAlpha^.precedantOrdreBonus := _premiereRecetteBonus;
            _premiereRecetteAlpha^.suivantOrdreBonus := _premiereRecetteBonus;

        end else begin
            // créer la cellule de la recette
            new(nouvelleRecette);
            nouvelleRecette^.valeur := recette;

            // insérer au début
            if not _estApresOrdreAlpha(recette.nom, _premiereRecetteAlpha^.valeur.nom) then begin
                _insererEntreAlpha(nouvelleRecette, _premiereRecetteAlpha^.precedantOrdreAlpha, _premiereRecetteAlpha);
                _premiereRecetteAlpha := nouvelleRecette;

            end else begin
                curseurAlpha := _premiereRecetteAlpha;
                while curseurAlpha <> NIL do begin
                    curseurAlpha := curseurAlpha^.precedantOrdreAlpha;
                    if _estApresOrdreAlpha(recette.nom, curseurAlpha^.valeur.nom) then begin
                        _insererEntreAlpha(nouvelleRecette, curseurAlpha, curseurAlpha^.suivantOrdreAlpha);
                        curseurAlpha := NIL;
                    end;
                end;
            end;

            // insérer au début
            if not _estApresOrdreBonus(recette.effet, _premiereRecetteBonus^.valeur.effet) then begin
                _insererEntreBonus(nouvelleRecette, _premiereRecetteBonus^.precedantOrdreBonus, _premiereRecetteBonus);
                _premiereRecetteBonus := nouvelleRecette;

            end else begin
                curseurBonus := _premiereRecetteBonus;
                while curseurBonus <> NIL do begin
                    curseurBonus := curseurBonus^.precedantOrdreBonus;
                    if _estApresOrdreBonus(recette.effet, curseurBonus^.valeur.effet) then begin
                        _insererEntreBonus(nouvelleRecette, curseurBonus, curseurBonus^.suivantOrdreBonus);
                        curseurBonus := NIL;
                    end;
                end;
            end;
        end;
    end;


    // calcule la taille de la dernière page
    procedure recettesChargees;
    begin
        _dernierePage := _nombreDeRecettes div TAILLE_PAGE_RECETTES;
        _tailleDernierePage := _nombreDeRecettes mod TAILLE_PAGE_RECETTES;
        if _tailleDernierePage = 0 then
            _tailleDernierePage := TAILLE_PAGE_RECETTES
        else
            _dernierePage += 1;
    end;

    procedure effacerRecettes;
    var
        curseur, precedent: _PtrCelluleRecette;
    begin
        // si la liste est déja vide, ne rien faire
        if _premiereRecetteAlpha <> NIL then begin
            // on parcours la liste en utilisant l'ordre alphabétique
            // "casser la boucle" en détachant le premier élément du dernier
            (_premiereRecetteAlpha^.precedantOrdreAlpha)^.suivantOrdreAlpha := NIL;

            curseur := _premiereRecetteAlpha;

            while curseur <> NIL do begin
                precedent := curseur;
                curseur := precedent^.suivantOrdreAlpha;
                dispose(precedent);
            end;

            initRecettes;
        end;
    end;


    procedure triAlphaRecettes;
    begin
        _modeTriUtilise := ALPHABETIQUE;
    end;

    procedure triBonusRecettes;
    begin
        _modeTriUtilise := PARBONUS;
    end;

    procedure premierePageRecettes;
    begin
        case _modeTriUtilise of
             ALPHABETIQUE: begin
                 _curseurPage := _premiereRecetteAlpha;
                 _pageCourante := 1;
             end;
             PARBONUS: begin
                 _curseurPage := _premiereRecetteBonus;
                 _pageCourante := 1;
             end;
        end;
    end;

    procedure pageSuivanteRecettes;
    var
        i: Integer;
    begin
        case _modeTriUtilise of
             ALPHABETIQUE: begin
                 if _pageCourante = _dernierePage then
                     _pageCourante := 1
                 else
                     _pageCourante += 1;                                
                 for i := 1 to taillePageRecettes do
                     _curseurPage := _curseurPage^.suivantOrdreAlpha;
             end;
             PARBONUS: begin
                 if _pageCourante = _dernierePage then
                     _pageCourante := 1
                 else
                     _pageCourante += 1; 
                 for i := 1 to taillePageRecettes do
                     _curseurPage := _curseurPage^.suivantOrdreBonus;
             end;
        end;
    end;

    procedure pagePrecedenteRecettes;
    var
        i: Integer;
    begin
        case _modeTriUtilise of
             ALPHABETIQUE: begin
                 if _pageCourante = 1 then
                     _pageCourante := _dernierePage
                 else
                     _pageCourante -= 1;
                 for i := 0 to taillePageRecettes do
                     _curseurPage := _curseurPage^.precedantOrdreAlpha;
             end;
             PARBONUS: begin
                 if _pageCourante = 1 then
                     _pageCourante := _dernierePage
                 else
                     _pageCourante -= 1;
                 for i := 0 to taillePageRecettes do
                     _curseurPage := _curseurPage^.precedantOrdreBonus;
             end;
        end;
    end;

    function pageCouranteRecettes: Integer;
    begin
        pageCouranteRecettes := _pageCourante;
    end;


    function lireRecette(numero: Integer): TypeRecette;
    var
        i: Integer;
        curseurRecette: _PtrCelluleRecette;
    begin
        curseurRecette := _curseurPage;
        case _modeTriUtilise of
             ALPHABETIQUE: begin
                 for i := 1 to numero do
                     curseurRecette := curseurRecette^.suivantOrdreAlpha;
             end;
             PARBONUS: begin
                 for i := 1 to numero do
                     curseurRecette := curseurRecette^.suivantOrdreBonus;
             end;
        end;
        lireRecette := curseurRecette^.valeur;
    end;


    function longueurMaxNomRecette: Integer;
    begin
        longueurMaxNomRecette := _longueurMax;
    end;


    function nombrePagesRecettes: Integer;
    begin
        nombrePagesRecettes := _dernierePage;
    end;

end.

