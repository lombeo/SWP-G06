<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="dao.TourDAO" %>
<%@ page import="model.City" %>
<%@ page import="java.util.List" %>
<%-- Document : home Created on : Feb 25, 2025, 3:19:54 PM Author : Lom --%>

    <!DOCTYPE html>
    <html lang="en">

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
        </style>
    </head>

    <body>
        <div id="webcrumbs">
            <div class="w-full">
                <header class="bg-sky-500 relative z-50">
                    <div class="container mx-auto px-6 py-3">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center gap-4"> <span class="material-symbols-outlined">phone</span>
                                <span>1900
                                    1839 - Từ 8:00 - 11:00 hàng ngày</span>
                            </div>
                            <div class="flex items-center space-x-8">
                                <% if (session.getAttribute("user") != null) { 
                                    model.User user = (model.User) session.getAttribute("user");
                                %>
                                    <div class="relative" x-data="{ isOpen: false }">
                                        <button @click="isOpen = !isOpen" 
                                                class="flex items-center space-x-3 focus:outline-none bg-gray-100 hover:bg-gray-200 rounded-full py-2 px-4">
                                            <img src="<%= user.getAvatar() != null && !user.getAvatar().isEmpty() ? 
                                                user.getAvatar() : 
                                                "https://ui-avatars.com/api/?name=" + user.getFullName() + "&background=random" %>" 
                                                 alt="avatar" 
                                                 class="w-8 h-8 rounded-full border-2 border-white"/>
                                            <span class="font-medium text-gray-700">Xin chào, <%= user.getFullName() %></span>
                                            <i class="fas fa-chevron-down text-gray-500 text-sm transition-transform duration-200"
                                               :class="{ 'transform rotate-180': isOpen }"></i>
                                        </button>
                                        
                                        <!-- Dropdown menu -->
                                        <div x-show="isOpen" 
                                             @click.away="isOpen = false"
                                             x-transition:enter="transition ease-out duration-200"
                                             x-transition:enter-start="opacity-0 transform scale-95"
                                             x-transition:enter-end="opacity-100 transform scale-100"
                                             x-transition:leave="transition ease-in duration-75"
                                             x-transition:leave-start="opacity-100 transform scale-100"
                                             x-transition:leave-end="opacity-0 transform scale-95"
                                             class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-2 z-50"
                                             style="display: none;">
                                            <a href="./user-profile" 
                                               class="flex items-center px-4 py-2 text-gray-800 hover:bg-gray-100 transition-colors duration-200">
                                                <i class="fas fa-user-circle text-gray-600 w-5"></i>
                                                <span class="ml-2">Thông tin của tôi</span>
                                            </a>
                                            <a href="my-bookings" 
                                               class="flex items-center px-4 py-2 text-gray-800 hover:bg-gray-100 transition-colors duration-200">
                                                <i class="fas fa-calendar-check text-gray-600 w-5"></i>
                                                <span class="ml-2">Đơn đặt tour</span>
                                            </a>
                                            <hr class="my-1 border-gray-200"/>
                                            <a href="logout" 
                                               class="flex items-center px-4 py-2 text-red-600 hover:bg-gray-100 transition-colors duration-200">
                                                <i class="fas fa-sign-out-alt text-red-600 w-5"></i>
                                                <span class="ml-2">Đăng xuất</span>
                                            </a>
                                        </div>
                                    </div>
                                <% } else { %>
                                    <div class="flex items-center space-x-4">
                                        <a href="login" class="text-gray-600 hover:text-gray-900">
                                            <i class="fas fa-sign-in-alt mr-1"></i>
                                            Đăng nhập
                                        </a>
                                        <a href="register"
                                            class="bg-blue-600 text-white px-6 py-2 rounded-full hover:bg-blue-700 transition duration-200">
                                            <i class="fas fa-user-plus mr-1"></i>
                                            Đăng ký
                                        </a>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </header>
                <nav class="flex items-center justify-between p-4 bg-white sticky top-0 z-40">
                    <a href="#" class="flex items-center">
                        <img src="./image/logo.svg" alt="TourNest Logo" style="height: 100px; width: auto;" />
                    </a>
                    <div class="flex items-center gap-8"> <a href="#" class="hover:text-blue-500 transition">Trang
                            chủ</a>
                        <a href="#" class="hover:text-blue-500 transition">Địa điểm</a> <a href="./tour"
                            class="hover:text-blue-500 transition">Tour</a> <a href="#"
                            class="hover:text-blue-500 transition">Đánh giá</a> <a href="#"
                            class="hover:text-blue-500 transition">Liên hệ</a>
                    </div>
                </nav>
                <main>
                    <div class="relative h-[600px]"> <img
                            src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e"
                            class="w-full h-full object-cover" alt="Beach" />
                        <div class="absolute inset-0 bg-black/20"></div>
                        <div class="absolute bottom-32 left-8 text-white">
                            <h1 class="text-4xl font-bold mb-2">Đặt tour du lịch!</h1>
                            <p>Hơn 500 tour du lịch trong nước từ Bắc vào Nam</p>
                        </div>
                        <div class="absolute right-8 top-1/2 -translate-y-1/2 text-white text-right">
                            <div class="flex items-center gap-2 mb-4"> <span
                                    class="material-symbols-outlined text-4xl">public</span>
                                <h2 class="text-4xl font-bold">Enjoy Your</h2>
                            </div>
                            <p class="text-6xl font-light italic mb-8">Traveling</p> <button
                                class="bg-white text-black px-8 py-2 rounded hover:bg-blue-50 transition">BOOK
                                NOW</button>
                            <p class="mt-4">TourNest.site.com</p>
                        </div>
                        <div
                            class="absolute -bottom-20 left-1/2 -translate-x-1/2 bg-white rounded-lg shadow-xl p-6 w-[800px]">
                            <form action="tour" method="GET" class="grid grid-cols-3 gap-4">
                                <div class="relative"> 
                                    <span class="material-symbols-outlined absolute left-3 top-3">location_on</span>
                                    <input type="text" name="search" placeholder="Bạn muốn đi đâu ?"
                                        class="w-full pl-10 pr-4 py-2 border rounded hover:border-blue-500 focus:border-blue-500 focus:outline-none transition" />
                                </div>
                                <div class="relative">
                                    <span class="material-symbols-outlined absolute left-3 top-3">calendar_month</span>
                                    <input type="date" name="date" placeholder="Chọn ngày khởi hành"
                                        class="w-full pl-10 pr-4 py-2 border rounded hover:border-blue-500 focus:border-blue-500 focus:outline-none transition"
                                        onfocus="this.showPicker()" onblur="if(!this.value) this.type='text'"
                                        onclick="this.type='date'" type="text" />
                                </div>
                                <div class="flex gap-4">
                                    <select name="departure" class="w-full pl-10 pr-4 py-2 border rounded hover:border-blue-500 focus:border-blue-500 focus:outline-none transition">
                                        <option value="">Khởi hành từ</option>
                                        <% 
                                        TourDAO tourDAO = new TourDAO();
                                        List<City> cities = tourDAO.getAllCities();
                                        for(City city : cities) { 
                                        %>
                                            <option value="<%= city.getId() %>"><%= city.getName() %></option>
                                        <% } %>
                                    </select>
                                    <button type="submit" class="bg-blue-500 text-white px-8 rounded hover:bg-blue-600 transition">Tìm</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="mt-32 px-8">
                        <div class="flex justify-center gap-16 mb-16">
                            <div class="text-center group cursor-pointer">
                                <div class="bg-blue-50 p-4 rounded-lg mb-2 group-hover:bg-blue-100 transition">
                                    <span class="material-symbols-outlined text-3xl">hiking</span> </div>
                                <p>Du lịch sinh thái</p>
                            </div>
                            <div class="text-center group cursor-pointer">
                                <div class="bg-blue-50 p-4 rounded-lg mb-2 group-hover:bg-blue-100 transition">
                                    <span class="material-symbols-outlined text-3xl">museum</span> </div>
                                <p>Du lịch văn hóa</p>
                            </div>
                            <div class="text-center group cursor-pointer">
                                <div class="bg-blue-50 p-4 rounded-lg mb-2 group-hover:bg-blue-100 transition">
                                    <span class="material-symbols-outlined text-3xl">landscape</span> </div>
                                <p>Du lịch nghỉ dưỡng</p>
                            </div>
                            <div class="text-center group cursor-pointer">
                                <div class="bg-blue-50 p-4 rounded-lg mb-2 group-hover:bg-blue-100 transition">
                                    <span class="material-symbols-outlined text-3xl">attractions</span> </div>
                                <p>Du lịch giải trí</p>
                            </div>
                            <div class="text-center group cursor-pointer">
                                <div class="bg-blue-50 p-4 rounded-lg mb-2 group-hover:bg-blue-100 transition">
                                    <span class="material-symbols-outlined text-3xl">diversity_3</span> </div>
                                <p>Du lịch gia đình</p>
                            </div>
                        </div>
                        <section class="mb-16">
                            <h2 class="text-2xl font-bold mb-8 text-center">CÁC ĐỊA ĐIỂM YÊU THÍCH</h2>
                            <p class="text-center mb-8 text-gray-600">Các địa điểm yêu thích của du khách đang giá
                                rẻ đợt
                                này, bạn hãm xét trải nghiệm của khách hàng</p>
                            <div class="grid grid-cols-2 gap-8">
                                <div class="relative h-[240px] rounded-lg overflow-hidden group cursor-pointer">
                                    <img src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                        alt="Đà Nẵng"
                                        class="w-full h-full object-cover group-hover:scale-110 transition duration-500" />
                                    <div class="absolute inset-0 bg-black/20 group-hover:bg-black/40 transition">
                                    </div>
                                    <h3 class="absolute bottom-4 left-4 text-white text-xl font-bold">Đà Nẵng</h3>
                                </div>
                                <div class="relative h-[240px] rounded-lg overflow-hidden group cursor-pointer">
                                    <img src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                        alt="Huế"
                                        class="w-full h-full object-cover group-hover:scale-110 transition duration-500" />
                                    <div class="absolute inset-0 bg-black/20 group-hover:bg-black/40 transition">
                                    </div>
                                    <h3 class="absolute bottom-4 left-4 text-white text-xl font-bold">Huế</h3>
                                </div>
                                <div class="relative h-[240px] rounded-lg overflow-hidden group cursor-pointer">
                                    <img src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                        alt="Cần Thơ"
                                        class="w-full h-full object-cover group-hover:scale-110 transition duration-500" />
                                    <div class="absolute inset-0 bg-black/20 group-hover:bg-black/40 transition">
                                    </div>
                                    <h3 class="absolute bottom-4 left-4 text-white text-xl font-bold">Cần Thơ</h3>
                                </div>
                                <div class="relative h-[240px] rounded-lg overflow-hidden group cursor-pointer">
                                    <img src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                        alt="Hạ Long"
                                        class="w-full h-full object-cover group-hover:scale-110 transition duration-500" />
                                    <div class="absolute inset-0 bg-black/20 group-hover:bg-black/40 transition">
                                    </div>
                                    <h3 class="absolute bottom-4 left-4 text-white text-xl font-bold">Hạ Long</h3>
                                </div>
                            </div>
                        </section>
                        <section class="mb-16">
                            <h2 class="text-2xl font-bold mb-8 text-center">Tour</h2>
                            <p class="text-center mb-8 text-gray-600">Các tour du lịch được tổ chức với đội ngũ nhân
                                viên
                                chuyên nghiệp</p>
                            <div class="grid grid-cols-3 gap-8">
                                <div class="bg-white rounded-lg shadow-lg overflow-hidden group">
                                    <div class="relative"> <img
                                            src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                            alt="Tour"
                                            class="w-full h-[200px] object-cover group-hover:scale-110 transition duration-500" />
                                        <span
                                            class="absolute top-4 right-4 material-symbols-outlined text-white bg-black/50 p-1 rounded-full cursor-pointer hover:bg-black/70 transition">favorite</span>
                                    </div>
                                    <div class="p-4">
                                        <h3 class="font-bold mb-2">Tour Tây Bắc</h3>
                                        <div class="flex items-center gap-2 text-sm text-gray-600 mb-2"> <span
                                                class="material-symbols-outlined">schedule</span> <span>4N3Đ</span>
                                            <span>|</span> <span>Số chỗ còn nhận: 30</span>
                                        </div>
                                        <div class="flex items-center gap-2 text-sm text-gray-600 mb-4"> <span
                                                class="material-symbols-outlined">calendar_today</span> <span>Khởi
                                                hành:
                                                25/02/2025</span> </div>
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <p class="text-sm text-gray-600">Giá từ:</p>
                                                <p class="text-xl font-bold text-blue-500">10.990.000 đ</p>
                                            </div> <button
                                                class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition">Đặt
                                                ngay</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="bg-white rounded-lg shadow-lg overflow-hidden group">
                                    <div class="relative"> <img
                                            src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                            alt="Tour"
                                            class="w-full h-[200px] object-cover group-hover:scale-110 transition duration-500" />
                                        <span
                                            class="absolute top-4 right-4 material-symbols-outlined text-white bg-black/50 p-1 rounded-full cursor-pointer hover:bg-black/70 transition">favorite</span>
                                    </div>
                                    <div class="p-4">
                                        <h3 class="font-bold mb-2">Tour Sapa</h3>
                                        <div class="flex items-center gap-2 text-sm text-gray-600 mb-2"> <span
                                                class="material-symbols-outlined">schedule</span> <span>4N3Đ</span>
                                            <span>|</span> <span>Số chỗ còn nhận: 30</span>
                                        </div>
                                        <div class="flex items-center gap-2 text-sm text-gray-600 mb-4"> <span
                                                class="material-symbols-outlined">calendar_today</span> <span>Khởi
                                                hành:
                                                25/02/2025</span> </div>
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <p class="text-sm text-gray-600">Giá từ:</p>
                                                <p class="text-xl font-bold text-blue-500">10.990.000 đ</p>
                                            </div> <button
                                                class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition">Đặt
                                                ngay</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="bg-white rounded-lg shadow-lg overflow-hidden group">
                                    <div class="relative"> <img
                                            src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                            alt="Tour"
                                            class="w-full h-[200px] object-cover group-hover:scale-110 transition duration-500" />
                                        <span
                                            class="absolute top-4 right-4 material-symbols-outlined text-white bg-black/50 p-1 rounded-full cursor-pointer hover:bg-black/70 transition">favorite</span>
                                    </div>
                                    <div class="p-4">
                                        <h3 class="font-bold mb-2">Tour Mộc Châu</h3>
                                        <div class="flex items-center gap-2 text-sm text-gray-600 mb-2"> <span
                                                class="material-symbols-outlined">schedule</span> <span>4N3Đ</span>
                                            <span>|</span> <span>Số chỗ còn nhận: 30</span>
                                        </div>
                                        <div class="flex items-center gap-2 text-sm text-gray-600 mb-4"> <span
                                                class="material-symbols-outlined">calendar_today</span> <span>Khởi
                                                hành:
                                                25/02/2025</span> </div>
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <p class="text-sm text-gray-600">Giá từ:</p>
                                                <p class="text-xl font-bold text-blue-500">10.990.000 đ</p>
                                            </div> <button
                                                class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition">Đặt
                                                ngay</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="text-center mt-8"> <button
                                    class="border border-blue-500 text-blue-500 px-8 py-2 rounded hover:bg-blue-50 transition">Xem
                                    tất cả</button> </div>
                        </section>
                        <section class="mb-16">
                            <h2 class="text-2xl font-bold mb-8 text-center">Ưu đãi giờ chót</h2>
                            <p class="text-center mb-8 text-gray-600">Nhanh tay nắm bắt cơ hội giảm giá cuối cùng.
                                Đặt ngay
                                để không bỏ lỡi</p>
                            <div class="grid grid-cols-3 gap-8">
                                <div class="bg-white rounded-lg shadow-lg overflow-hidden group">
                                    <div class="relative"> <img
                                            src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                            alt="Tour"
                                            class="w-full h-[200px] object-cover group-hover:scale-110 transition duration-500" />
                                        <span
                                            class="absolute top-4 right-4 material-symbols-outlined text-white bg-black/50 p-1 rounded-full cursor-pointer hover:bg-black/70 transition">favorite</span>
                                        <div
                                            class="absolute top-4 left-4 bg-red-500 text-white px-2 py-1 rounded text-sm">
                                            Giờ chót</div>
                                        <div
                                            class="absolute bottom-4 right-4 bg-white text-red-500 px-2 py-1 rounded text-sm font-bold">
                                            02:24:45</div>
                                    </div>
                                    <div class="p-4">
                                        <h3 class="font-bold mb-2">Tour Bắc - Nam</h3>
                                        <div class="flex items-center gap-2 text-sm text-gray-600 mb-2"> <span
                                                class="material-symbols-outlined">schedule</span> <span>4N3Đ</span>
                                            <span>|</span> <span>Số chỗ còn nhận: 1</span>
                                        </div>
                                        <div class="flex items-center gap-2 text-sm text-gray-600 mb-4"> <span
                                                class="material-symbols-outlined">calendar_today</span> <span>Khởi
                                                hành:
                                                20/02/2025</span> </div>
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <p class="text-sm text-gray-600">Giá từ:</p>
                                                <p class="text-xl font-bold text-red-500">4.290.000 đ</p>
                                                <p class="text-sm line-through text-gray-400">4.990.000 đ</p>
                                            </div> <button
                                                class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 transition">Đặt
                                                ngay</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="bg-white rounded-lg shadow-lg overflow-hidden group">
                                    <div class="relative"> <img
                                            src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                            alt="Tour"
                                            class="w-full h-[200px] object-cover group-hover:scale-110 transition duration-500" />
                                        <span
                                            class="absolute top-4 right-4 material-symbols-outlined text-white bg-black/50 p-1 rounded-full cursor-pointer hover:bg-black/70 transition">favorite</span>
                                        <div
                                            class="absolute top-4 left-4 bg-red-500 text-white px-2 py-1 rounded text-sm">
                                            Giờ chót</div>
                                        <div
                                            class="absolute bottom-4 right-4 bg-white text-red-500 px-2 py-1 rounded text-sm font-bold">
                                            03:55:34</div>
                                    </div>
                                    <div class="p-4">
                                        <h3 class="font-bold mb-2">Tour HCM - Safari</h3>
                                        <div class="flex items-center gap-2 text-sm text-gray-600 mb-2"> <span
                                                class="material-symbols-outlined">schedule</span> <span>4N3Đ</span>
                                            <span>|</span> <span>Số chỗ còn nhận: 7</span>
                                        </div>
                                        <div class="flex items-center gap-2 text-sm text-gray-600 mb-4"> <span
                                                class="material-symbols-outlined">calendar_today</span> <span>Khởi
                                                hành:
                                                20/02/2025</span> </div>
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <p class="text-sm text-gray-600">Giá từ:</p>
                                                <p class="text-xl font-bold text-red-500">4.990.000 đ</p>
                                                <p class="text-sm line-through text-gray-400">5.990.000 đ</p>
                                            </div> <button
                                                class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 transition">Đặt
                                                ngay</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="bg-white rounded-lg shadow-lg overflow-hidden group">
                                    <div class="relative"> <img
                                            src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                            alt="Tour"
                                            class="w-full h-[200px] object-cover group-hover:scale-110 transition duration-500" />
                                        <span
                                            class="absolute top-4 right-4 material-symbols-outlined text-white bg-black/50 p-1 rounded-full cursor-pointer hover:bg-black/70 transition">favorite</span>
                                        <div
                                            class="absolute top-4 left-4 bg-red-500 text-white px-2 py-1 rounded text-sm">
                                            Giờ chót</div>
                                        <div
                                            class="absolute bottom-4 right-4 bg-white text-red-500 px-2 py-1 rounded text-sm font-bold">
                                            03:24:42</div>
                                    </div>
                                    <div class="p-4">
                                        <h3 class="font-bold mb-2">Tour Quy Nhơn</h3>
                                        <div class="flex items-center gap-2 text-sm text-gray-600 mb-2"> <span
                                                class="material-symbols-outlined">schedule</span> <span>4N3Đ</span>
                                            <span>|</span> <span>Số chỗ còn nhận: 4</span>
                                        </div>
                                        <div class="flex items-center gap-2 text-sm text-gray-600 mb-4"> <span
                                                class="material-symbols-outlined">calendar_today</span> <span>Khởi
                                                hành:
                                                20/02/2025</span> </div>
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <p class="text-sm text-gray-600">Giá từ:</p>
                                                <p class="text-xl font-bold text-red-500">4.890.000 đ</p>
                                                <p class="text-sm line-through text-gray-400">5.490.000 đ</p>
                                            </div> <button
                                                class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 transition">Đặt
                                                ngay</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="text-center mt-8"> <button
                                    class="border border-blue-500 text-blue-500 px-8 py-2 rounded hover:bg-blue-50 transition">Xem
                                    tất cả</button> </div>
                        </section>
                        <section class="mb-16">
                            <h2 class="text-2xl font-bold mb-8 text-center">Đánh giá</h2>
                            <p class="text-center mb-8 text-gray-600">Ý kiến của khách hàng về trải nghiệm của dịch
                                vụ khác
                                của TourNest</p>
                            <div class="grid grid-cols-3 gap-8">
                                <div class="bg-white rounded-lg shadow-lg p-6"> <img
                                        src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                        alt="Review" class="w-full h-[200px] object-cover rounded-lg mb-4" />
                                    <p class="text-gray-600 mb-4">&quot;Mình đã có một trải nghiệm tuyệt vời với
                                        dịch vụ của
                                        TourNest. Đồng hành cùng TourNest, mình đã thấy được những dịch vụ tốt nhất
                                        và khó
                                        quên trong cuộc hành trình của mình.&quot;</p>
                                    <p class="font-bold">- Chi Linh - Nha Trang 2024-</p>
                                </div>
                                <div class="bg-white rounded-lg shadow-lg p-6"> <img
                                        src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                        alt="Review" class="w-full h-[200px] object-cover rounded-lg mb-4" />
                                    <p class="text-gray-600 mb-4">&quot;Sau khi có những trải nghiệm tuyệt vời cùng
                                        dịch vụ
                                        của TourNest, gia đình nhanh chóng sắp xếp để sử dụng những dịch vụ tốt khác
                                        của các
                                        bạn và không thể khiến tôi phàn nàn về những dịch vụ của TourNest.&quot;</p>
                                    <p class="font-bold">- Anh Minh - Hạ Long 2024-</p>
                                </div>
                                <div class="bg-white rounded-lg shadow-lg p-6"> <img
                                        src="https://images.unsplash.com/photo-1583417319070-4a69db38a482"
                                        alt="Review" class="w-full h-[200px] object-cover rounded-lg mb-4" />
                                    <p class="text-gray-600 mb-4">&quot;Du lịch là nơi để để lại những trải nghiệm
                                        khó quên
                                        và TourNest đã mang lại cho gia đình tôi những trải nghiệm tốt nhất.&quot;
                                    </p>
                                    <p class="font-bold">- Chi Hạnh - Đà Lạt 2024-</p>
                                </div>
                            </div>
                        </section>
                    </div>
                </main>
                <footer class="bg-gray-100 px-8 py-12 w-full">
                    <div class="grid grid-cols-4 gap-8 mb-8">
                        <div>
                            <h3 class="text-2xl font-bold mb-4">TourNest</h3>
                            <p class="text-gray-600 mb-4">KCNC Hòa Lạc - Thạch Thất - Hà Nội</p>
                            <p class="text-gray-600">(+84)8341679645</p>
                            <p class="text-gray-600 mb-4">tournest@gmail.com</p>
                            <div class="flex gap-4"> <a href="#"
                                    class="text-gray-600 hover:text-blue-500 transition"> <i
                                        class="fa-brands fa-facebook text-2xl"></i> </a> <a href="#"
                                    class="text-gray-600 hover:text-blue-500 transition"> <i
                                        class="fa-brands fa-twitter text-2xl"></i> </a> <a href="#"
                                    class="text-gray-600 hover:text-blue-500 transition"> <i
                                        class="fa-brands fa-instagram text-2xl"></i> </a> <a href="#"
                                    class="text-gray-600 hover:text-blue-500 transition"> <i
                                        class="fa-brands fa-youtube text-2xl"></i> </a> </div>
                        </div>
                        <div>
                            <h3 class="font-bold mb-4">Thông tin</h3>
                            <ul class="space-y-2">
                                <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">Trợ giúp</a>
                                </li>
                                <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">Chính sách bảo
                                        mật</a>
                                </li>
                                <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">Điều khoản sử
                                        dụng</a>
                                </li>
                                <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">Chính sách đổi
                                        trả và
                                        lấy lại tiền</a></li>
                            </ul>
                        </div>
                        <div>
                            <h3 class="font-bold mb-4">Hỗ trợ</h3>
                            <ul class="space-y-2">
                                <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">FAQs</a></li>
                                <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">Liên hệ</a>
                                </li>
                                <li><a href="#" class="text-gray-600 hover:text-blue-500 transition">Blog</a></li>
                            </ul>
                        </div>
                        <div>
                            <h3 class="font-bold mb-4">Tải ứng dụng</h3>
                            <div class="space-y-4"> <button
                                    class="bg-black text-white px-6 py-2 rounded flex items-center gap-2 hover:bg-gray-800 transition w-full">
                                    <i class="fa-brands fa-apple text-2xl"></i>
                                    <div class="text-left">
                                        <p class="text-xs">Download on the</p>
                                        <p class="font-bold">App Store</p>
                                    </div>
                                </button> </div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
    </body>

    </html>