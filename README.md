# MLP_PSET_01

Proyecto en **R** con una estructura de **importar**, **preparar** y **describir** datos (p. ej., PWT/Eurostat) y generar **figuras descriptivas** (con foco en Italia y comparaciones Norte–Sur).

---

## Estructura general del repositorio

La lógica del proyecto está organizada por **etapas**. En cada etapa encontrarás, como regla general:

- `scr/` → **scripts** de R
- `output/` → **productos** generados por esa etapa (bases intermedias `.rds`, figuras `.png`, etc.)


<!------------------------------>
<!------------------------------>
## Estructura:

<pre>
MLP_PSET_01/
├─ 01_data/          # Etapa 1: importación y construcción de insumos
├─ 02_prepare_data/  # Etapa 2: limpieza, armonización y preparación
├─ 03_descriptive/   # Etapa 3: análisis descriptivo y visualizaciones
├─ 99_document/      # Reporte (si aplica)
├─ 00_packages.R     # Carga/instalación de paquetes
├─ RUN_ME.R          # Ejecuta todos los scripts del proyecto
└─ README.md
</pre>


<!------------------------------>
<!------------------------------>
## Cómo correr el proyecto

### Opción recomendada: ejecutar todo
`RUN_ME.R` está pensado como el **script maestro**: **corre todos los scripts del pipeline** en el orden necesario (de importación → preparación → descriptivos).

Desde la carpeta raíz del proyecto:

