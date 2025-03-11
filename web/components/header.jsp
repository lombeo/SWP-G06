<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>TourNest - Trang chủ</title>
            <script src="https://cdn.tailwindcss.com"></script>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
            <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
            <style>
                @import url(https://fonts.googleapis.com/css2?family=Poppins&display=swap);

                @import url(https://fonts.googleapis.com/css2?family=Roboto&display=swap);

                @import url(https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200);

                @import url(https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css);

                /*! tailwindcss v3.4.11 | MIT License | https://tailwindcss.com*/
                *,
                :after,
                :before {
                    border: 0 solid #e5e7eb;
                    box-sizing: border-box;
                }

                :after,
                :before {
                    --tw-content: "";
                }

                :host,
                html {
                    line-height: 1.5;
                    -webkit-text-size-adjust: 100%;
                    font-family:
                        Poppins,
                        ui-sans-serif,
                        system-ui,
                        sans-serif,
                        Apple Color Emoji,
                        Segoe UI Emoji,
                        Segoe UI Symbol,
                        Noto Color Emoji;
                    font-feature-settings: normal;
                    font-variation-settings: normal;
                    -moz-tab-size: 4;
                    tab-size: 4;
                    -webkit-tap-highlight-color: transparent;
                }

                body {
                    line-height: inherit;
                    margin: 0;
                    padding: 0;
                    min-height: 100vh;
                    background: linear-gradient(135deg, #ffffff, #d4d4d4);
                }

                hr {
                    border-top-width: 1px;
                    color: inherit;
                    height: 0;
                }

                abbr:where([title]) {
                    text-decoration: underline dotted;
                }

                h1,
                h2,
                h3,
                h4,
                h5,
                h6 {
                    font-size: inherit;
                    font-weight: inherit;
                }

                a {
                    color: inherit;
                    text-decoration: inherit;
                }

                b,
                strong {
                    font-weight: bolder;
                }

                code,
                kbd,
                pre,
                samp {
                    font-family:
                        ui-monospace,
                        SFMono-Regular,
                        Menlo,
                        Monaco,
                        Consolas,
                        Liberation Mono,
                        Courier New,
                        monospace;
                    font-feature-settings: normal;
                    font-size: 1em;
                    font-variation-settings: normal;
                }

                small {
                    font-size: 80%;
                }

                sub,
                sup {
                    font-size: 75%;
                    line-height: 0;
                    position: relative;
                    vertical-align: baseline;
                }

                sub {
                    bottom: -0.25em;
                }

                sup {
                    top: -0.5em;
                }

                table {
                    border-collapse: collapse;
                    border-color: inherit;
                    text-indent: 0;
                }

                button,
                input,
                optgroup,
                select,
                textarea {
                    color: inherit;
                    font-family: inherit;
                    font-feature-settings: inherit;
                    font-size: 100%;
                    font-variation-settings: inherit;
                    font-weight: inherit;
                    letter-spacing: inherit;
                    line-height: inherit;
                    margin: 0;
                    padding: 0;
                }

                button,
                select {
                    text-transform: none;
                }

                button,
                input:where([type="button"]),
                input:where([type="reset"]),
                input:where([type="submit"]) {
                    -webkit-appearance: button;
                    background-color: transparent;
                    background-image: none;
                }

                :-moz-focusring {
                    outline: auto;
                }

                :-moz-ui-invalid {
                    box-shadow: none;
                }

                progress {
                    vertical-align: baseline;
                }

                ::-webkit-inner-spin-button,
                ::-webkit-outer-spin-button {
                    height: auto;
                }

                [type="search"] {
                    -webkit-appearance: textfield;
                    outline-offset: -2px;
                }

                ::-webkit-search-decoration {
                    -webkit-appearance: none;
                }

                ::-webkit-file-upload-button {
                    -webkit-appearance: button;
                    font: inherit;
                }

                summary {
                    display: list-item;
                }

                blockquote,
                dd,
                dl,
                figure,
                h1,
                h2,
                h3,
                h4,
                h5,
                h6,
                hr,
                p,
                pre {
                    margin: 0;
                }

                fieldset {
                    margin: 0;
                }

                fieldset,
                legend {
                    padding: 0;
                }

                menu,
                ol,
                ul {
                    list-style: none;
                    margin: 0;
                    padding: 0;
                }

                dialog {
                    padding: 0;
                }

                textarea {
                    resize: vertical;
                }

                input::placeholder,
                textarea::placeholder {
                    color: #9ca3af;
                    opacity: 1;
                }

                [role="button"],
                button {
                    cursor: pointer;
                }

                :disabled {
                    cursor: default;
                }

                audio,
                canvas,
                embed,
                iframe,
                img,
                object,
                svg,
                video {
                    display: block;
                    vertical-align: middle;
                }

                img,
                video {
                    height: auto;
                    max-width: 100%;
                }

                [hidden] {
                    display: none;
                }

                *,
                :after,
                :before {
                    --tw-border-spacing-x: 0;
                    --tw-border-spacing-y: 0;
                    --tw-translate-x: 0;
                    --tw-translate-y: 0;
                    --tw-rotate: 0;
                    --tw-skew-x: 0;
                    --tw-skew-y: 0;
                    --tw-scale-x: 1;
                    --tw-scale-y: 1;
                    --tw-pan-x: ;
                    --tw-pan-y: ;
                    --tw-pinch-zoom: ;
                    --tw-scroll-snap-strictness: proximity;
                    --tw-gradient-from-position: ;
                    --tw-gradient-via-position: ;
                    --tw-gradient-to-position: ;
                    --tw-ordinal: ;
                    --tw-slashed-zero: ;
                    --tw-numeric-figure: ;
                    --tw-numeric-spacing: ;
                    --tw-numeric-fraction: ;
                    --tw-ring-inset: ;
                    --tw-ring-offset-width: 0px;
                    --tw-ring-offset-color: #fff;
                    --tw-ring-color: rgba(59, 130, 246, 0.5);
                    --tw-ring-offset-shadow: 0 0 #0000;
                    --tw-ring-shadow: 0 0 #0000;
                    --tw-shadow: 0 0 #0000;
                    --tw-shadow-colored: 0 0 #0000;
                    --tw-blur: ;
                    --tw-brightness: ;
                    --tw-contrast: ;
                    --tw-grayscale: ;
                    --tw-hue-rotate: ;
                    --tw-invert: ;
                    --tw-saturate: ;
                    --tw-sepia: ;
                    --tw-drop-shadow: ;
                    --tw-backdrop-blur: ;
                    --tw-backdrop-brightness: ;
                    --tw-backdrop-contrast: ;
                    --tw-backdrop-grayscale: ;
                    --tw-backdrop-hue-rotate: ;
                    --tw-backdrop-invert: ;
                    --tw-backdrop-opacity: ;
                    --tw-backdrop-saturate: ;
                    --tw-backdrop-sepia: ;
                    --tw-contain-size: ;
                    --tw-contain-layout: ;
                    --tw-contain-paint: ;
                    --tw-contain-style: ;
                }

                ::backdrop {
                    --tw-border-spacing-x: 0;
                    --tw-border-spacing-y: 0;
                    --tw-translate-x: 0;
                    --tw-translate-y: 0;
                    --tw-rotate: 0;
                    --tw-skew-x: 0;
                    --tw-skew-y: 0;
                    --tw-scale-x: 1;
                    --tw-scale-y: 1;
                    --tw-pan-x: ;
                    --tw-pan-y: ;
                    --tw-pinch-zoom: ;
                    --tw-scroll-snap-strictness: proximity;
                    --tw-gradient-from-position: ;
                    --tw-gradient-via-position: ;
                    --tw-gradient-to-position: ;
                    --tw-ordinal: ;
                    --tw-slashed-zero: ;
                    --tw-numeric-figure: ;
                    --tw-numeric-spacing: ;
                    --tw-numeric-fraction: ;
                    --tw-ring-inset: ;
                    --tw-ring-offset-width: 0px;
                    --tw-ring-offset-color: #fff;
                    --tw-ring-color: rgba(59, 130, 246, 0.5);
                    --tw-ring-offset-shadow: 0 0 #0000;
                    --tw-ring-shadow: 0 0 #0000;
                    --tw-shadow: 0 0 #0000;
                    --tw-shadow-colored: 0 0 #0000;
                    --tw-blur: ;
                    --tw-brightness: ;
                    --tw-contrast: ;
                    --tw-grayscale: ;
                    --tw-hue-rotate: ;
                    --tw-invert: ;
                    --tw-saturate: ;
                    --tw-sepia: ;
                    --tw-drop-shadow: ;
                    --tw-backdrop-blur: ;
                    --tw-backdrop-brightness: ;
                    --tw-backdrop-contrast: ;
                    --tw-backdrop-grayscale: ;
                    --tw-backdrop-hue-rotate: ;
                    --tw-backdrop-invert: ;
                    --tw-backdrop-opacity: ;
                    --tw-backdrop-saturate: ;
                    --tw-backdrop-sepia: ;
                    --tw-contain-size: ;
                    --tw-contain-layout: ;
                    --tw-contain-paint: ;
                    --tw-contain-style: ;
                }

                #webcrumbs .absolute {
                    position: absolute;
                }

                #webcrumbs .relative {
                    position: relative;
                }

                #webcrumbs .sticky {
                    position: sticky;
                }

                #webcrumbs .inset-0 {
                    inset: 0;
                }

                #webcrumbs .-bottom-20 {
                    bottom: -80px;
                }

                #webcrumbs .bottom-32 {
                    bottom: 128px;
                }

                #webcrumbs .bottom-4 {
                    bottom: 16px;
                }

                #webcrumbs .left-1\/2 {
                    left: 50%;
                }

                #webcrumbs .left-3 {
                    left: 12px;
                }

                #webcrumbs .left-4 {
                    left: 16px;
                }

                #webcrumbs .left-8 {
                    left: 32px;
                }

                #webcrumbs .right-4 {
                    right: 16px;
                }

                #webcrumbs .right-8 {
                    right: 32px;
                }

                #webcrumbs .top-0 {
                    top: 0;
                }

                #webcrumbs .top-1\/2 {
                    top: 50%;
                }

                #webcrumbs .top-3 {
                    top: 12px;
                }

                #webcrumbs .top-4 {
                    top: 16px;
                }

                #webcrumbs .z-50 {
                    z-index: 50;
                }

                #webcrumbs .mb-16 {
                    margin-bottom: 64px;
                }

                #webcrumbs .mb-2 {
                    margin-bottom: 8px;
                }

                #webcrumbs .mb-4 {
                    margin-bottom: 16px;
                }

                #webcrumbs .mb-8 {
                    margin-bottom: 32px;
                }

                #webcrumbs .mt-32 {
                    margin-top: 128px;
                }

                #webcrumbs .mt-4 {
                    margin-top: 16px;
                }

                #webcrumbs .mt-8 {
                    margin-top: 32px;
                }

                #webcrumbs .flex {
                    display: flex;
                }

                #webcrumbs .grid {
                    display: grid;
                }

                #webcrumbs .h-\[200px\] {
                    height: 200px;
                }

                #webcrumbs .h-\[240px\] {
                    height: 240px;
                }

                #webcrumbs .h-\[600px\] {
                    height: 600px;
                }

                #webcrumbs .h-full {
                    height: 100%;
                }

                #webcrumbs .w-\[1200px\] {
                    width: 1200px;
                }

                #webcrumbs .w-\[800px\] {
                    width: 800px;
                }

                #webcrumbs .w-full {
                    width: 100%;
                }

                #webcrumbs .-translate-x-1\/2 {
                    --tw-translate-x: -50%;
                }

                #webcrumbs .-translate-x-1\/2,
                #webcrumbs .-translate-y-1\/2 {
                    transform: translate(var(--tw-translate-x), var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y));
                }

                #webcrumbs .-translate-y-1\/2 {
                    --tw-translate-y: -50%;
                }

                #webcrumbs .cursor-pointer {
                    cursor: pointer;
                }

                #webcrumbs .grid-cols-2 {
                    grid-template-columns: repeat(2, minmax(0, 1fr));
                }

                #webcrumbs .grid-cols-3 {
                    grid-template-columns: repeat(3, minmax(0, 1fr));
                }

                #webcrumbs .grid-cols-4 {
                    grid-template-columns: repeat(4, minmax(0, 1fr));
                }

                #webcrumbs .flex-row {
                    flex-direction: row;
                }

                #webcrumbs .items-center {
                    align-items: center;
                }

                #webcrumbs .justify-center {
                    justify-content: center;
                }

                #webcrumbs .justify-between {
                    justify-content: space-between;
                }

                #webcrumbs .gap-16 {
                    gap: 64px;
                }

                #webcrumbs .gap-2 {
                    gap: 8px;
                }

                #webcrumbs .gap-4 {
                    gap: 16px;
                }

                #webcrumbs .gap-8 {
                    gap: 32px;
                }

                #webcrumbs :is(.space-y-2 > :not([hidden]) ~ :not([hidden])) {
                    --tw-space-y-reverse: 0;
                    margin-bottom: calc(8px * var(--tw-space-y-reverse));
                    margin-top: calc(8px * (1 - var(--tw-space-y-reverse)));
                }

                #webcrumbs :is(.space-y-4 > :not([hidden]) ~ :not([hidden])) {
                    --tw-space-y-reverse: 0;
                    margin-bottom: calc(16px * var(--tw-space-y-reverse));
                    margin-top: calc(16px * (1 - var(--tw-space-y-reverse)));
                }

                #webcrumbs .overflow-hidden {
                    overflow: hidden;
                }

                #webcrumbs .rounded {
                    border-radius: 12px;
                }

                #webcrumbs .rounded-full {
                    border-radius: 9999px;
                }

                #webcrumbs .rounded-lg {
                    border-radius: 24px;
                }

                #webcrumbs .border {
                    border-width: 1px;
                }

                #webcrumbs .border-b {
                    border-bottom-width: 1px;
                }

                #webcrumbs .border-blue-500 {
                    --tw-border-opacity: 1;
                    border-color: rgb(59 130 246 / var(--tw-border-opacity));
                }

                #webcrumbs .bg-black {
                    --tw-bg-opacity: 1;
                    background-color: rgb(0 0 0 / var(--tw-bg-opacity));
                }

                #webcrumbs .bg-black\/20 {
                    background-color: rgba(0, 0, 0, 0.2);
                }

                #webcrumbs .bg-black\/50 {
                    background-color: rgba(0, 0, 0, 0.5);
                }

                #webcrumbs .bg-blue-50 {
                    --tw-bg-opacity: 1;
                    background-color: rgb(239 246 255 / var(--tw-bg-opacity));
                }

                #webcrumbs .bg-blue-500 {
                    --tw-bg-opacity: 1;
                    background-color: rgb(59 130 246 / var(--tw-bg-opacity));
                }

                #webcrumbs .bg-gray-100 {
                    --tw-bg-opacity: 1;
                    background-color: rgb(243 244 246 / var(--tw-bg-opacity));
                }

                #webcrumbs .bg-red-500 {
                    --tw-bg-opacity: 1;
                    background-color: rgb(239 68 68 / var(--tw-bg-opacity));
                }

                #webcrumbs .bg-white {
                    --tw-bg-opacity: 1;
                    background-color: rgb(255 255 255 / var(--tw-bg-opacity));
                }

                #webcrumbs .object-cover {
                    object-fit: cover;
                }

                #webcrumbs .p-1 {
                    padding: 4px;
                }

                #webcrumbs .p-4 {
                    padding: 16px;
                }

                #webcrumbs .p-6 {
                    padding: 24px;
                }

                #webcrumbs .px-2 {
                    padding-left: 8px;
                    padding-right: 8px;
                }

                #webcrumbs .px-4 {
                    padding-left: 16px;
                    padding-right: 16px;
                }

                #webcrumbs .px-6 {
                    padding-left: 24px;
                    padding-right: 24px;
                }

                #webcrumbs .px-8 {
                    padding-left: 32px;
                    padding-right: 32px;
                }

                #webcrumbs .py-1 {
                    padding-bottom: 4px;
                    padding-top: 4px;
                }

                #webcrumbs .py-12 {
                    padding-bottom: 48px;
                    padding-top: 48px;
                }

                #webcrumbs .py-2 {
                    padding-bottom: 8px;
                    padding-top: 8px;
                }

                #webcrumbs .pl-10 {
                    padding-left: 40px;
                }

                #webcrumbs .pr-4 {
                    padding-right: 16px;
                }

                #webcrumbs .text-left {
                    text-align: left;
                }

                #webcrumbs .text-center {
                    text-align: center;
                }

                #webcrumbs .text-right {
                    text-align: right;
                }

                #webcrumbs .text-2xl {
                    font-size: 24px;
                    line-height: 31.200000000000003px;
                }

                #webcrumbs .text-3xl {
                    font-size: 30px;
                    line-height: 36px;
                }

                #webcrumbs .text-4xl {
                    font-size: 36px;
                    line-height: 41.4px;
                }

                #webcrumbs .text-6xl {
                    font-size: 60px;
                    line-height: 66px;
                }

                #webcrumbs .text-sm {
                    font-size: 14px;
                    line-height: 21px;
                }

                #webcrumbs .text-xl {
                    font-size: 20px;
                    line-height: 28px;
                }

                #webcrumbs .text-xs {
                    font-size: 12px;
                    line-height: 19.200000000000003px;
                }

                #webcrumbs .font-bold {
                    font-weight: 700;
                }

                #webcrumbs .font-light {
                    font-weight: 300;
                }

                #webcrumbs .italic {
                    font-style: italic;
                }

                #webcrumbs .text-black {
                    --tw-text-opacity: 1;
                    color: rgb(0 0 0 / var(--tw-text-opacity));
                }

                #webcrumbs .text-blue-500 {
                    --tw-text-opacity: 1;
                    color: rgb(59 130 246 / var(--tw-text-opacity));
                }

                #webcrumbs .text-gray-400 {
                    --tw-text-opacity: 1;
                    color: rgb(156 163 175 / var(--tw-text-opacity));
                }

                #webcrumbs .text-gray-600 {
                    --tw-text-opacity: 1;
                    color: rgb(75 85 99 / var(--tw-text-opacity));
                }

                #webcrumbs .text-red-500 {
                    --tw-text-opacity: 1;
                    color: rgb(239 68 68 / var(--tw-text-opacity));
                }

                #webcrumbs .text-white {
                    --tw-text-opacity: 1;
                    color: rgb(255 255 255 / var(--tw-text-opacity));
                }

                #webcrumbs .line-through {
                    text-decoration-line: line-through;
                }

                #webcrumbs .shadow-lg {
                    --tw-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1),
                        0 4px 6px -4px rgba(0, 0, 0, 0.1);
                    --tw-shadow-colored: 0 10px 15px -3px var(--tw-shadow-color),
                        0 4px 6px -4px var(--tw-shadow-color);
                }

                #webcrumbs .shadow-lg,
                #webcrumbs .shadow-xl {
                    box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),
                        var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
                }

                #webcrumbs .shadow-xl {
                    --tw-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1),
                        0 8px 10px -6px rgba(0, 0, 0, 0.1);
                    --tw-shadow-colored: 0 20px 25px -5px var(--tw-shadow-color),
                        0 8px 10px -6px var(--tw-shadow-color);
                }

                #webcrumbs .transition {
                    transition-duration: 0.15s;
                    transition-property: color, background-color, border-color,
                        text-decoration-color, fill, stroke, opacity, box-shadow, transform, filter,
                        backdrop-filter;
                    transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
                }

                #webcrumbs .duration-500 {
                    transition-duration: 0.5s;
                }

                #webcrumbs {
                    font-family: Roboto !important;
                    font-size: 16px !important;
                }

                #webcrumbs .hover\:border-blue-500:hover {
                    --tw-border-opacity: 1;
                    border-color: rgb(59 130 246 / var(--tw-border-opacity));
                }

                #webcrumbs .hover\:bg-black\/70:hover {
                    background-color: rgba(0, 0, 0, 0.7);
                }

                #webcrumbs .hover\:bg-blue-50:hover {
                    --tw-bg-opacity: 1;
                    background-color: rgb(239 246 255 / var(--tw-bg-opacity));
                }

                #webcrumbs .hover\:bg-blue-600:hover {
                    --tw-bg-opacity: 1;
                    background-color: rgb(37 99 235 / var(--tw-bg-opacity));
                }

                #webcrumbs .hover\:bg-gray-800:hover {
                    --tw-bg-opacity: 1;
                    background-color: rgb(31 41 55 / var(--tw-bg-opacity));
                }

                #webcrumbs .hover\:bg-red-600:hover {
                    --tw-bg-opacity: 1;
                    background-color: rgb(220 38 38 / var(--tw-bg-opacity));
                }

                #webcrumbs .hover\:text-blue-500:hover {
                    --tw-text-opacity: 1;
                    color: rgb(59 130 246 / var(--tw-text-opacity));
                }

                #webcrumbs .focus\:border-blue-500:focus {
                    --tw-border-opacity: 1;
                    border-color: rgb(59 130 246 / var(--tw-border-opacity));
                }

                #webcrumbs .focus\:outline-none:focus {
                    outline: 2px solid transparent;
                    outline-offset: 2px;
                }

                #webcrumbs :is(.group:hover .group-hover\:scale-110) {
                    --tw-scale-x: 1.1;
                    --tw-scale-y: 1.1;
                    transform: translate(var(--tw-translate-x), var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y));
                }

                #webcrumbs :is(.group:hover .group-hover\:bg-black\/40) {
                    background-color: rgba(0, 0, 0, 0.4);
                }

                #webcrumbs :is(.group:hover .group-hover\:bg-blue-100) {
                    --tw-bg-opacity: 1;
                    background-color: rgb(219 234 254 / var(--tw-bg-opacity));
                }

                #webcrumbs .bg-sky-500 {
                    --tw-bg-opacity: 1;
                    background-color: rgb(14 165 233 / var(--tw-bg-opacity));
                }

                .dropdown {
                    display: none;
                    position: absolute;
                    right: 0;
                    margin-top: 0.5rem;
                    width: 12rem;
                    background-color: white;
                    border-radius: 0.375rem;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    padding: 0.25rem 0;
                }

                .group:hover .dropdown {
                    display: block;
                }
            </style>
        </head>

        <header class="bg-sky-500 flex flex-col md:flex-row justify-between items-center py-2 px-4 text-white text-sm w-full">
            <div class="flex items-center mb-2 md:mb-0">
                <span class="material-symbols-outlined mr-1">call</span>
                <span>1900 1839 - Từ 8:00 - 11:00 hàng ngày</span>
            </div>
            <div>
                <% if (session.getAttribute("user") != null) { 
                    model.User user = (model.User) session.getAttribute("user"); 
                %>
                    <div class="relative" x-data="{ isOpen: false }">
                        <button @click="isOpen = !isOpen" class="flex items-center space-x-3 focus:outline-none bg-gray-100 hover:bg-gray-200 rounded-full py-2 px-4">
                            <img 
                                src="<%= user.getAvatar() != null && !user.getAvatar().isEmpty() ? user.getAvatar() : "https://ui-avatars.com/api/?name=" + user.getFullName() + "&background=random" %>" 
                                alt="avatar" 
                                class="w-8 h-8 rounded-full border-2 border-white"
                            />
                            <span class="font-medium text-gray-700">Xin chào, <%= user.getFullName() %></span>
                            <i class="fas fa-chevron-down text-gray-500 text-sm transition-transform duration-200" :class="{ 'transform rotate-180': isOpen }"></i>
                        </button>
                        <!-- Dropdown menu -->
                        <div x-show="isOpen" @click.away="isOpen = false" class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-2 z-50">
                            <a href="./user-profile" class="flex items-center px-4 py-2 text-gray-800 hover:bg-gray-100 transition-colors duration-200">
                                <i class="fas fa-user-circle text-gray-600 w-5"></i>
                                <span class="ml-2">Thông tin của tôi</span>
                            </a>
                            <a href="my-bookings" class="flex items-center px-4 py-2 text-gray-800 hover:bg-gray-100 transition-colors duration-200">
                                <i class="fas fa-calendar-check text-gray-600 w-5"></i>
                                <span class="ml-2">Đơn đặt tour</span>
                            </a>
                            <hr class="my-1 border-gray-200" />
                            <a href="logout" class="flex items-center px-4 py-2 text-red-600 hover:bg-gray-100 transition-colors duration-200">
                                <i class="fas fa-sign-out-alt text-red-600 w-5"></i>
                                <span class="ml-2">Đăng xuất</span>
                            </a>
                        </div>
                    </div>
                <% } else { %>
                    <div class="flex items-center space-x-4">
                        <a href="login" class="text-white hover:text-gray-200">
                            <i class="fas fa-sign-in-alt mr-1"></i>
                            Đăng nhập
                        </a>
                        <a href="register" class="bg-white text-sky-500 px-6 py-2 rounded-full hover:bg-gray-100 transition duration-200">
                            <i class="fas fa-user-plus mr-1"></i>
                            Đăng ký
                        </a>
                    </div>
                <% } %>
            </div>
        </header>

        <nav class="py-4 px-4 md:px-8">
            <div class="flex justify-center items-center">
                <a href="./home.jsp" class="flex items-center">
                    <img src="./image/logo.svg" alt="TourNest Logo" class="h-16 md:h-24 w-auto" />
                </a>
            </div>
            <p class="text-center mt-2">Hãy đến và trải nghiệm những dịch vụ tour du lịch của Tour<span class="text-sky-500">Nest</span></p>
        </nav>