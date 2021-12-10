unit unitListeRecettes;

interface

    type
        EnumBonus = (AUCUN, REGENERATION, CRITIQUE, FORCE);

        TypeRecette = record
            nom: String;
            effet: EnumBonus;
        end;

    const TAILLE_PAGE_RECETTES = 10;


    procedure initRecettes;


    procedure insererRecette(recette: TypeRecette);


    procedure effacerRecettes;


    procedure triAlphaRecettes;

    procedure triBonusRecettes;

    procedure premierePageRecettes;

    procedure pageSuivanteRecettes;

    procedure pagePrecedenteRecettes;

    function pageCouranteRecettes: Integer;


    function lireRecette: TypeRecette;


    procedure afficherRecettes;


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

    var
        _premiereRecetteAlpha,
        _premiereRecetteBonus,
        _curseurPage,
        _curseurRecette: _PtrCelluleRecette;
        _pageCourante: Integer;
        _modeTriUtilise: _ModeTri;

    procedure initRecettes;
    begin
        _premiereRecetteAlpha := NIL;   
        _premiereRecetteBonus := NIL;
        _curseurPage := NIL;
        _curseurRecette := NIL;
    end;


    // str1 > str2
    function _estApresOrdreAlpha(str1, str2: String): boolean;
    var
        i, tailleMin: Integer;
    begin
        i := 1;
        if length(str1) > length(str2) then
            tailleMin := length(str2)
        else
            tailleMin := length(str1);

        while true do
            if i > tailleMin then begin
                _estApresOrdreAlpha := length(str1) > length(str2);
                break;
            end else if str1[i] = str2[i] then
                i += 1
            else begin
                _estApresOrdreAlpha := ord(str1[i]) > ord(str2[i]);
                break;
            end;
    end;

    // eff1 > eff2
    function _estApresOrdreBonus(eff1, eff2: EnumBonus): boolean;
    begin
        _estApresOrdreBonus := ord(eff1) > ord(eff2);
    end;

    procedure _insererEntreAlpha(nouvelElement, elementAvant, elementApres: _PtrCelluleRecette);
    begin                                                   
        nouvelElement^.precedantOrdreAlpha := elementAvant;
        nouvelElement^.suivantOrdreAlpha := elementApres;      
        elementAvant^.suivantOrdreAlpha := nouvelElement;
        elementApres^.precedantOrdreAlpha := nouvelElement;
    end;

    procedure insererRecette(recette: TypeRecette);
    var
        curseurAlpha, curseurBonus, nouvelleRecette: _PtrCelluleRecette;
    begin
        if _premiereRecetteAlpha = NIL then begin
            new(_premiereRecetteAlpha);
            _premiereRecetteBonus := _premiereRecetteAlpha;

            _premiereRecetteAlpha^.valeur := recette;
            _premiereRecetteAlpha^.precedantOrdreAlpha := _premiereRecetteAlpha;
            _premiereRecetteAlpha^.suivantOrdreAlpha := _premiereRecetteAlpha;
            _premiereRecetteAlpha^.precedantOrdreBonus := _premiereRecetteBonus;
            _premiereRecetteAlpha^.suivantOrdreBonus := _premiereRecetteBonus;

        end else begin
            new(nouvelleRecette);
            nouvelleRecette^.valeur := recette;

            if _estApresOrdreAlpha(_premiereRecetteAlpha^.valeur.nom, recette.nom) then begin
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

            // À FAIRE
        end;
    end;


    procedure effacerRecettes;
    var
        curseur, precedent: _PtrCelluleRecette;
    begin
        // si la liste est déja vide, ne rien faire
        if _premiereRecetteAlpha <> NIL then begin
            // on parcours la liste en utilisant l'ordre alphabétique
            // casser la "boucle" en détachant le premier élément du dernier
            (_premiereRecetteAlpha^.precedantOrdreAlpha)^.suivantOrdreAlpha := NIL;

            curseur := _premiereRecetteAlpha;

            while curseur <> NIL do begin
                precedent := curseur;
                curseur := precedent^.suivantOrdreAlpha;
                dispose(precedent);
            end;

            _premiereRecetteAlpha := NIL;
            _premiereRecetteBonus := NIL;
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
             ALPHABETIQUE: _curseurPage := _premiereRecetteAlpha;
             PARBONUS:     _curseurPage := _premiereRecetteBonus;
        end;
    end;

    procedure pageSuivanteRecettes;
    begin
        case _modeTriUtilise of
             ALPHABETIQUE: begin
                 { À FAIRE }
             end;
             PARBONUS: begin
                 { À FAIRE }
             end;
        end;
    end;

    procedure pagePrecedenteRecettes;
    begin
        case _modeTriUtilise of
             ALPHABETIQUE: begin
                 { À FAIRE }
             end;
             PARBONUS: begin
                 { À FAIRE }
             end;
        end;
    end;

    function pageCouranteRecettes: Integer;
    begin
        pageCouranteRecettes := _pageCourante;
    end;


    function lireRecette: TypeRecette;
    begin
        // À FAIRE
    end;


    procedure afficherRecettes;
    var
        c: _PtrCelluleRecette;
    begin
        writeln('=== ORDRE ALPHAB'#144'TIQUE ===');
        writeln(_premiereRecetteAlpha^.valeur.nom);
        c := _premiereRecetteAlpha^.suivantOrdreAlpha;
        while c <> _premiereRecetteAlpha do begin
            writeln(c^.valeur.nom);
            c := c^.suivantOrdreAlpha;
        end;
    end;

end.

