<%-- 
    Document   : calendar
    Created on : Feb 28, 2025, 1:58:20 AM
    Author     : Lom
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>My Webcrumbs Plugin</title>
        <style>
            @import url(https://fonts.googleapis.com/css2?family=Poppins&display=swap);
            @import url(https://fonts.googleapis.com/css2?family=Roboto&display=swap);
            @import url(https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200);
        </style>
    </head>
    <body>
        <div id="webcrumbs">
            <div class="w-[700px] rounded-lg border border-gray-200 p-6">
                <div class="flex items-center justify-between mb-6">
                    <button class="text-blue-500 hover:text-blue-700 transition-colors">
                        <span class="material-symbols-outlined">arrow_back_ios</span>
                    </button>
                    <h2 class="text-2xl font-bold text-blue-600">Tháng 2/2025</h2>
                    <button class="text-blue-500 hover:text-blue-700 transition-colors">
                        <span class="material-symbols-outlined">arrow_forward_ios</span>
                    </button>
                </div>
                <div class="grid grid-cols-7 gap-2 mb-4">
                    <div class="text-center font-medium">T2</div>
                    <div class="text-center font-medium">T3</div>
                    <div class="text-center font-medium">T4</div>
                    <div class="text-center font-medium">T5</div>
                    <div class="text-center font-medium">T6</div>
                    <div class="text-center font-medium">T7</div>
                    <div class="text-center font-medium">CN</div>
                </div>
                <div class="grid grid-cols-7 gap-2 mb-4">
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">27</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">28</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">29</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">30</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">31</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">1</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">2</div>
                </div>
                <div class="grid grid-cols-7 gap-2 mb-4">
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">3</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">4</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">5</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">6</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">7</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">8</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">9</div>
                </div>
                <div class="grid grid-cols-7 gap-2 mb-4">
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">10</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">11</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">12</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">13</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">14</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">15</div>
                    <div class="bg-gray-100 rounded p-3 text-center hover:bg-gray-200 transition-colors">16</div>
                </div>
                <div class="grid grid-cols-7 gap-2 mb-4">
                    <div class="border rounded p-3 text-center hover:bg-gray-50 transition-colors cursor-pointer">
                        17
                    </div>
                    <div class="border rounded p-3 text-center hover:bg-gray-50 transition-colors cursor-pointer">
                        18
                    </div>
                    <div class="border rounded p-3 text-center hover:bg-gray-50 transition-colors cursor-pointer">
                        19
                    </div>
                    <div
                        class="border border-red-300 rounded p-2 text-center hover:shadow-md transition-all cursor-pointer relative"
                    >
                        <div class="font-medium">20</div>
                        <div class="text-red-500 text-sm font-medium">5,890 K</div>
                        <span class="absolute -top-1 -right-1 text-yellow-500">
                            <svg
                                xmlns="http://www.w3.org/2000/svg"
                                class="h-6 w-6"
                                fill="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"
                                ></path>
                            </svg>
                        </span>
                    </div>
                    <div class="border rounded p-3 text-center hover:bg-gray-50 transition-colors cursor-pointer">
                        21
                    </div>
                    <div class="border rounded p-3 text-center hover:bg-gray-50 transition-colors cursor-pointer">
                        22
                    </div>
                    <div
                        class="border border-red-300 rounded p-2 text-center hover:shadow-md transition-all cursor-pointer"
                    >
                        <div class="font-medium">23</div>
                        <div class="text-red-500 text-sm font-medium">5,990 K</div>
                    </div>
                </div>
                <div class="grid grid-cols-7 gap-2 mb-6">
                    <div class="border rounded p-3 text-center hover:bg-gray-50 transition-colors cursor-pointer">
                        24
                    </div>
                    <div class="border rounded p-3 text-center hover:bg-gray-50 transition-colors cursor-pointer">
                        25
                    </div>
                    <div class="border rounded p-3 text-center hover:bg-gray-50 transition-colors cursor-pointer">
                        26
                    </div>
                    <div
                        class="border border-red-300 rounded p-2 text-center hover:shadow-md transition-all cursor-pointer"
                    >
                        <div class="font-medium">27</div>
                        <div class="text-red-500 text-sm font-medium">6,390 K</div>
                    </div>
                    <div class="border rounded p-3 text-center hover:bg-gray-50 transition-colors cursor-pointer">
                        28
                    </div>
                    <div class="col-span-2"></div>
                </div>
                <p class="text-red-500 italic text-sm">Quý khách vui lòng chọn ngày phù hợp</p>
            </div>
        </div>

        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = {
                content: ["./src/**/*.{html,js}"],
                theme: {
                    name: "Custom",
                    fontFamily: {
                        sans: [
                            "Poppins",
                            "ui-sans-serif",
                            "system-ui",
                            "sans-serif",
                            '"Apple Color Emoji"',
                            '"Segoe UI Emoji"',
                            '"Segoe UI Symbol"',
                            '"Noto Color Emoji"'
                        ]
                    },
                    extend: {
                        fontFamily: {
                            title: [
                                "Poppins",
                                "ui-sans-serif",
                                "system-ui",
                                "sans-serif",
                                '"Apple Color Emoji"',
                                '"Segoe UI Emoji"',
                                '"Segoe UI Symbol"',
                                '"Noto Color Emoji"'
                            ],
                            body: [
                                "Roboto",
                                "ui-sans-serif",
                                "system-ui",
                                "sans-serif",
                                '"Apple Color Emoji"',
                                '"Segoe UI Emoji"',
                                '"Segoe UI Symbol"',
                                '"Noto Color Emoji"'
                            ]
                        },
                        colors: {
                            neutral: {
                                50: "#E0F7FA",
                                100: "#D9F0F3",
                                200: "#D3E8EB",
                                300: "#CCE1E4",
                                400: "#C5D9DC",
                                500: "#BED2D5",
                                600: "#5A6364",
                                700: "#434A4B",
                                800: "#2D3132",
                                900: "#161919",
                                DEFAULT: "#E0F7FA"
                            },
                            primary: {
                                50: "#ecf7ff",
                                100: "#d5ebff",
                                200: "#b5deff",
                                300: "#82caff",
                                400: "#47abff",
                                500: "#1d86ff",
                                600: "#0563ff",
                                700: "#004cf6",
                                800: "#073eca",
                                900: "#0d399b",
                                950: "#0d245e",
                                DEFAULT: "#073eca"
                            }
                        }
                    },
                    fontSize: {
                        xs: ["12px", {lineHeight: "19.200000000000003px"}],
                        sm: ["14px", {lineHeight: "21px"}],
                        base: ["16px", {lineHeight: "25.6px"}],
                        lg: ["18px", {lineHeight: "27px"}],
                        xl: ["20px", {lineHeight: "28px"}],
                        "2xl": ["24px", {lineHeight: "31.200000000000003px"}],
                        "3xl": ["30px", {lineHeight: "36px"}],
                        "4xl": ["36px", {lineHeight: "41.4px"}],
                        "5xl": ["48px", {lineHeight: "52.800000000000004px"}],
                        "6xl": ["60px", {lineHeight: "66px"}],
                        "7xl": ["72px", {lineHeight: "75.60000000000001px"}],
                        "8xl": ["96px", {lineHeight: "100.80000000000001px"}],
                        "9xl": ["128px", {lineHeight: "134.4px"}]
                    },
                    borderRadius: {
                        none: "0px",
                        sm: "6px",
                        DEFAULT: "12px",
                        md: "18px",
                        lg: "24px",
                        xl: "36px",
                        "2xl": "48px",
                        "3xl": "72px",
                        full: "9999px"
                    },
                    spacing: {
                        0: "0px",
                        1: "4px",
                        2: "8px",
                        3: "12px",
                        4: "16px",
                        5: "20px",
                        6: "24px",
                        7: "28px",
                        8: "32px",
                        9: "36px",
                        10: "40px",
                        11: "44px",
                        12: "48px",
                        14: "56px",
                        16: "64px",
                        20: "80px",
                        24: "96px",
                        28: "112px",
                        32: "128px",
                        36: "144px",
                        40: "160px",
                        44: "176px",
                        48: "192px",
                        52: "208px",
                        56: "224px",
                        60: "240px",
                        64: "256px",
                        72: "288px",
                        80: "320px",
                        96: "384px",
                        px: "1px",
                        0.5: "2px",
                        1.5: "6px",
                        2.5: "10px",
                        3.5: "14px"
                    }
                },
                plugins: [],
                important: "#webcrumbs"
            }
        </script>
    </body>
</html>
