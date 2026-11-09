!INC Local Scripts.EAConstants - JScript
/*
 * ==========================================================================================
 * SISTEMA CLÍNICA VIDA SALUD - DIAGRAMA: ANALIZAR PAQUETE (7 PAQUETES DEL SISTEMA)
 * ==========================================================================================
 * Archivo: Analizar_Paquetes_Ejemplo_EA.js
 * Descripción: Script JScript para Sparx Systems Enterprise Architect (v12/v14/v15/v16/v17).
 * Genera el diagrama de análisis de paquetes con los 7 PAQUETES DEL SISTEMA y sus relaciones «use»:
 * 
 * 1. LOS 7 PAQUETES:
 *    - P1: Seguridad y Autenticación (CU01 - CU04)
 *    - P2: Gestión de Usuarios y RBAC (CU05 - CU09)
 *    - P3: Bitácora y Auditoría (CU10, CU11) [Base transversal ancha]
 *    - P4: Gestión de Pacientes (CU12 - CU17)
 *    - P5: Gestión Médica y Horarios (CU18 - CU21)
 *    - P6: Gestión de Citas Médicas (CU22 - CU26)
 *    - P7: Reportes Administrativos (CU27 - CU30, CU36)
 * 
 * 2. DISEÑO GRÁFICO (SIMÉTRICO Y AGRADABLE):
 *    - Estructura en 3 columnas perfectamente alineadas:
 *        Columna 1: P1 (Superior) | P4 (Intermedio)
 *        Columna 2: P2 (Superior) | P6 (Intermedio)
 *        Columna 3: P5 (Superior) | P7 (Intermedio)
 *        Base Transversal: P3 (Barra inferior continua que abarca todo el ancho)
 *    - Marco exterior (Boundary): Lavanda suave (#ECEEF8) con borde pizarra (#9CA3AF).
 *    - Paquetes UML: Menta / Aqua pastel (#D5F6F2) con borde teal (#0D9488).
 *    - Tipografía: Arial 12 pt (fontsz=120) para títulos y 11 pt para CUs.
 * ==========================================================================================
 */

// Función segura de log en consola para EA y WScript
function Log(msg) {
    try {
        if (typeof Session !== "undefined") {
            Session.Output(msg);
            return;
        }
    } catch (e1) {}

    try {
        if (typeof WScript !== "undefined") {
            WScript.Echo(msg);
            return;
        }
    } catch (e2) {}
}

// Helper para convertir color Hex (#RRGGBB) a entero BGR de Enterprise Architect
function hexToBgr(hex) {
    if (hex.charAt(0) == '#') {
        hex = hex.substring(1);
    }
    var r = parseInt(hex.substring(0, 2), 16);
    var g = parseInt(hex.substring(2, 4), 16);
    var b = parseInt(hex.substring(4, 6), 16);
    return (b * 65536) + (g * 256) + r;
}

// Helper para aplicar color, bordes y tipografía Arial a un DiagramObject
function styleDiagramObject(diagObj, bgHex, borderHex, borderWidth, fontSizeDeciPoints) {
    var bgrBg = hexToBgr(bgHex);
    var bgrBorder = hexToBgr(borderHex);
    var bWidth = borderWidth || 1;
    var fSize = fontSizeDeciPoints || 120; // 120 decipuntos = 12 pt

    try {
        diagObj.BackgroundColor = bgrBg;
        diagObj.BorderColor = bgrBorder;
        diagObj.BorderWidth = bWidth;
    } catch (e) {}

    // Tipografía Arial 12pt nítida y BGR
    diagObj.Style = "BCol=" + bgrBg + ";BFmt=0;LCol=" + bgrBorder + ";LWth=" + bWidth + ";font=Arial;fontsz=" + fSize + ";pitch=34;";
    diagObj.Update();
}

function main() {
    Log("========================================================================");
    Log(" GENERANDO DIAGRAMA: ANALIZAR PAQUETE (7 PAQUETES DEL SISTEMA) ");
    Log(" DISEÑO AGRADABLE: MENTA PASTEL | MARCO LAVANDA | ARIAL 12 PT ");
    Log("========================================================================");

    var eaRepo = null;
    if (typeof Repository !== "undefined") {
        eaRepo = Repository;
    } else {
        try {
            var eaApp = new ActiveXObject("EA.App");
            eaRepo = eaApp.Repository;
        } catch (e) {
            Log("[ERROR] No se pudo obtener la instancia del Repositorio de EA: " + e.message);
            return;
        }
    }

    if (!eaRepo) {
        Log("[ERROR] El objeto Repository no está disponible.");
        return;
    }

    try {
        eaRepo.EnsureOutputVisible("Script");
    } catch (e) {}

    var targetPackage = eaRepo.GetTreeSelectedPackage();
    if (!targetPackage) {
        if (eaRepo.Models.Count > 0) {
            targetPackage = eaRepo.Models.GetAt(0);
        } else {
            Log("[ERROR] Por favor selecciona un paquete en el Project Browser.");
            return;
        }
    }

    Log("-> Paquete destino seleccionado: " + targetPackage.Name);

    // 1. Crear Paquete contenedor independiente
    var rootPkg = targetPackage.Packages.AddNew("Analizar Paquetes - Sistema Completo (7 Paquetes)", "");
    rootPkg.Notes = "Diagrama de análisis de paquetes con los 7 subsistemas funcionales de la plataforma web Clínica Vida Salud:\n" +
                    "- P1: Seguridad y Autenticación (CU01 - CU04)\n" +
                    "- P2: Gestión de Usuarios y RBAC (CU05 - CU09)\n" +
                    "- P3: Bitácora y Auditoría (CU10, CU11)\n" +
                    "- P4: Gestión de Pacientes (CU12 - CU17)\n" +
                    "- P5: Gestión Médica y Horarios (CU18 - CU21)\n" +
                    "- P6: Gestión de Citas Médicas (CU22 - CU26)\n" +
                    "- P7: Reportes Administrativos (CU27 - CU30, CU36)";
    rootPkg.Update();
    targetPackage.Packages.Refresh();

    // 2. Crear el Diagrama UML de Paquetes
    var pkgDiagram = rootPkg.Diagrams.AddNew("5.4 Analizar de paquete (7 Paquetes)", "Package");
    pkgDiagram.Notes = "Análisis de los 7 Paquetes del Sistema con diseño simétrico de 3 columnas y tipografía Arial 12pt.";
    pkgDiagram.Update();
    rootPkg.Diagrams.Refresh();

    // =========================================================================
    // PALETA DE COLORES
    // =========================================================================
    var COLORS = {
        frameBg:        "#ECEEF8", // Fondo del marco (Lavanda muy suave)
        frameBorder:    "#9CA3AF", // Borde del marco (Gris suave)
        packageBg:      "#D5F6F2", // Fondo del paquete (Aqua / Menta pastel)
        packageBorder:  "#0D9488"  // Borde del paquete (Teal oscuro corporativo)
    };

    var elementsMap = {};

    function addElementToDiagram(name, type, stereotype, left, right, top, bottom, bgHex, borderHex, borderWidth, fontSize) {
        var el = rootPkg.Elements.AddNew(name, type);
        if (stereotype && stereotype.length > 0) {
            el.Stereotype = stereotype;
        }
        el.Update();

        var coordStr = "l=" + left + ";r=" + right + ";t=" + top + ";b=" + bottom + ";";
        var diagObj = pkgDiagram.DiagramObjects.AddNew(coordStr, "");
        diagObj.ElementID = el.ElementID;
        diagObj.Update();

        if (bgHex && borderHex) {
            styleDiagramObject(diagObj, bgHex, borderHex, borderWidth, fontSize);
        }

        elementsMap[name] = el;
        return el;
    }

    // =========================================================================
    // 3. MARCO CONTENEDOR (BOUNDARY)
    //    Ancho = 1140 px, Alto = 570 px
    // =========================================================================
    Log("-> Creando Marco: 'Análisis de Paquetes - 7 Paquetes del Sistema'...");

    var frameBoundary = addElementToDiagram(
        "Análisis de Paquetes - Sistema Completo (P1 a P7)",
        "Boundary", "",
        40, 1180, -30, -600,
        COLORS.frameBg, COLORS.frameBorder, 1, 120
    );

    // =========================================================================
    // 4. CREACIÓN DE LOS 7 PAQUETES (DISPOSICIÓN EN 3 COLUMNAS Y BASE ANCHA)
    //    Columna 1: x = 70 a 390   (Centro: 230)
    //    Columna 2: x = 430 a 750  (Centro: 590)
    //    Columna 3: x = 790 a 1110 (Centro: 950)
    // =========================================================================
    Log("-> Creando los 7 paquetes del sistema...");

    // FILA 1 (Superior): Y = -90 a -180 (Alto: 90 px)
    // P1: Columna 1
    var p1 = addElementToDiagram(
        "P1 - Seguridad y Autenticación\n(CU01 - CU04)",
        "Package", "",
        70, 390, -90, -180,
        COLORS.packageBg, COLORS.packageBorder, 1, 120
    );

    // P2: Columna 2
    var p2 = addElementToDiagram(
        "P2 - Gestión de Usuarios y RBAC\n(CU05 - CU09)",
        "Package", "",
        430, 750, -90, -180,
        COLORS.packageBg, COLORS.packageBorder, 1, 120
    );

    // P5: Columna 3
    var p5 = addElementToDiagram(
        "P5 - Gestión Médica y Horarios\n(CU18 - CU21)",
        "Package", "",
        790, 1110, -90, -180,
        COLORS.packageBg, COLORS.packageBorder, 1, 120
    );

    // FILA 2 (Intermedia): Y = -270 a -360 (Alto: 90 px)
    // P4: Columna 1
    var p4 = addElementToDiagram(
        "P4 - Gestión de Pacientes\n(CU12 - CU17)",
        "Package", "",
        70, 390, -270, -360,
        COLORS.packageBg, COLORS.packageBorder, 1, 120
    );

    // P6: Columna 2
    var p6 = addElementToDiagram(
        "P6 - Gestión de Citas Médicas\n(CU22 - CU26)",
        "Package", "",
        430, 750, -270, -360,
        COLORS.packageBg, COLORS.packageBorder, 1, 120
    );

    // P7: Columna 3 (Séptimo Paquete del Sistema)
    var p7 = addElementToDiagram(
        "P7 - Reportes Administrativos\n(CU27 - CU30, CU36)",
        "Package", "",
        790, 1110, -270, -360,
        COLORS.packageBg, COLORS.packageBorder, 1, 120
    );

    // FILA 3 (Inferior Transversal Ancho): Y = -480 a -560 (Alto: 80 px)
    // P3: Barra horizontal continua a lo largo de toda la base (x = 70 a 1110)
    var p3 = addElementToDiagram(
        "P3 - Bitácora y Auditoría\n(CU10, CU11)",
        "Package", "",
        70, 1110, -480, -560,
        COLORS.packageBg, COLORS.packageBorder, 1, 120
    );

    // =========================================================================
    // 5. RELACIONES DE DEPENDENCIA («use»)
    // =========================================================================
    Log("-> Creando relaciones de dependencia «use» entre los 7 paquetes...");

    function addUseDependency(sourceEl, targetEl) {
        if (!sourceEl || !targetEl) return null;
        try {
            var con = sourceEl.Connectors.AddNew("", "Dependency");
            con.SupplierID = targetEl.ElementID;
            con.Stereotype = "use";
            con.Direction = "Source -> Destination";
            con.Update();
            sourceEl.Connectors.Refresh();
            return con;
        } catch (e) {
            Log("[WARN] No se pudo crear conector: " + e.message);
            return null;
        }
    }

    // A) Relaciones operativas en Fila 1 y Fila 2
    addUseDependency(p2, p1); // P2 Usuarios -> P1 Seguridad (Horizontal izquierda)
    addUseDependency(p4, p6); // P4 Pacientes -> P6 Citas Médicas (Horizontal derecha)
    addUseDependency(p7, p6); // P7 Reportes -> P6 Citas Médicas (Horizontal izquierda)
    addUseDependency(p6, p5); // P6 Citas Médicas -> P5 Médicos y Horarios (Diagonal superior derecha)
    addUseDependency(p7, p5); // P7 Reportes -> P5 Médicos y Horarios (Vertical hacia arriba)

    // B) Relaciones verticales hacia P3 (Bitácora y Auditoría Transversal)
    addUseDependency(p4, p3); // P4 Pacientes -> P3 Bitácora (Vertical recta abajo, Columna 1)
    addUseDependency(p6, p3); // P6 Citas Médicas -> P3 Bitácora (Vertical recta abajo, Columna 2)
    addUseDependency(p7, p3); // P7 Reportes -> P3 Bitácora (Vertical recta abajo, Columna 3)
    addUseDependency(p1, p3); // P1 Seguridad -> P3 Bitácora
    addUseDependency(p2, p3); // P2 Usuarios -> P3 Bitácora
    addUseDependency(p5, p3); // P5 Médicos -> P3 Bitácora

    // Refrescar y guardar el modelo
    rootPkg.Elements.Refresh();
    rootPkg.Packages.Refresh();
    pkgDiagram.Update();

    try {
        eaRepo.ReloadDiagram(pkgDiagram.DiagramID);
        eaRepo.RefreshModelView(rootPkg.PackageID);
        eaRepo.ShowInProjectView(rootPkg);
    } catch (e) {}

    Log("========================================================================");
    Log(" ¡DIAGRAMA DE LOS 7 PAQUETES GENERADO CON ÉXITO! ");
    Log(" Paquete: 'Analizar Paquetes - Sistema Completo (7 Paquetes)'");
    Log(" Diagrama: '5.4 Analizar de paquete (7 Paquetes)'");
    Log("========================================================================");

    try {
        if (typeof Session !== "undefined") {
            Session.Prompt("¡Generación completada con éxito!\n\nSe ha creado el diagrama con los 7 PAQUETES del sistema:\n• P1: Seguridad y Autenticación\n• P2: Gestión de Usuarios y RBAC\n• P3: Bitácora y Auditoría (Base transversal)\n• P4: Gestión de Pacientes\n• P5: Gestión Médica y Horarios\n• P6: Gestión de Citas Médicas\n• P7: Reportes Administrativos\n\nDiseño simétrico en 3 columnas, tipografía Arial 12 pt y colores pastel corporativos.", 0);
        }
    } catch (e) {}
}

// Iniciar ejecución
main();
