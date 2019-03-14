// LAYOUT SETTINGS
const CANVAS_HEIGHT = 500;
const CANVAS_WIDTH = 1200;

const TEXT_LABEL_GUTTER = 100;
const NUMERAL_LABEL_GUTTER = 40;
const DIMENSION_LABEL_Y_OFFSET = 0;

const LEFT_PADDING = 350;
const RIGHT_PADDING = 200;
const TOP_PADDING = 80;
const BOTTOM_PADDING = 30;

// MARKER SETTINGS
const CIRCLE_RADIUS = 10;
const SQ_SIDE_LENGTH = 20;
const SQ_CORNER_RADIUS = 2;
const CIRCLE_OPACITY = 1; // [0.0 - 1.0]
const VIZ3_ACCENT_COLOR = "#76448A";
const VIZ4_C1_ACCENT_COLOR = "#1A5276";
const VIZ4_C2_ACCENT_COLOR = "#FA8072";

// DATA SETTINGS
const COUNTRIES_COUNT = 155;
const VIZ3_INIT_COUNTRY = "United States";
const VIZ4_INIT_COUNTRY1 = "United States";
const VIZ4_INIT_COUNTRY2 = "United States";


// LINE SETTINGS
const GRAPH_LINE_WIDTH = 1;
const GRAPH_LINE_COLOR = "gray";
const DASHARRAY_STYLE = "5,5";
const RANKING_GRIDLINES = [1, 30, 60, 90, 120, 150];

// INTERACTION SETTINGS
const TRANSITION_DURATION = 1000;
const IN_VIZ_LABEL_COLOR = "#9b9b9b";

const DIMENSIONS_RANK = [{
        'column_name': "Happiness",
        'display_name': "Happiness"
    },

    {
        'column_name': "GDPperCapita",
        'display_name': "GDPperCapita"
    },

    {
        'column_name': "Corruption",
        'display_name': "Corruption"
    },

    {
        'column_name': "Unemployment",
        'display_name': "Unemployment"
    },

    {
        'column_name': "Inflation",
        'display_name': "Inflation"
    },

    {
        'column_name': "FreedomOfReligion",
        'display_name': "FreedomOfReligion"
    },

    {
        'column_name': "FreedomOfExpression",
        'display_name': "FreedomOfExpression"
    },

    {
        'column_name': "Life_Expectancy",
        'display_name': "Life Expectancy"
    },

    {
        'column_name': "Energy",
        'display_name': "Energy"
    },

    {
        'column_name': "Electricity",
        'display_name': "Electricity"
    },
];

// const DIMENSIONS_SCORE = [{
//         'column_name': "Happiness_Score",
//         'display_name': "Happiness"
//     },

//     {
//         'column_name': "Economy_GDP_Per_Capita",
//         'display_name': "GDP Per Capita"
//     },

//     {
//         'column_name': "Family",
//         'display_name': "Family"
//     },

//     {
//         'column_name': "Freedom",
//         'display_name': "Freedom"
//     },

//     {
//         'column_name': "Generosity",
//         'display_name': "Generosity"
//     },

//     {
//         'column_name': "Health_Life_Expectancy",
//         'display_name': "Life Expectancy"
//     },

//     {
//         'column_name': "Trust_Government_Corruption",
//         'display_name': "Trust in Government"
//     }
// ];

var countryInfo,
    countryInfoMap,
    viz3_svg,
    viz4_svg,
    xScale,
    yScale,
    viz3_xScale,
    viz3_yScale;


var viz3_ranking_data = [1, 1, 1, 1, 1, 1, 1,1,1,1];
var viz4_country1_ranking_data = [1, 1, 1, 1, 1, 1, 1,1,1];
var viz4_country2_ranking_data = [1, 1, 1, 1, 1, 1, 1,1,1];
var axis_coords = [0, 0, 0, 0, 0, 0, 0,0,0,0];

// function continentToColor(continent) {
//     switch (continent) {
//         case "Asia":
//             return "F8E21C";
//         case "Africa":
//             return "DB5082";
//         case "South America":
//             return "000000";
//         case "North America":
//             return "bbbbbb";
//         case "Europe":
//             return "C1C2FF";
//         case "Oceania":
//             return "9A3CFF";
//         default:
//             return "red";
//     }
// }