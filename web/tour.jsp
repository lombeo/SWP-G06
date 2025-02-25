<%-- Document : tour Created on : Feb 25, 2025, 3:21:31 PM Author : Lom --%>

    <%@ page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ page import="java.util.*" %>
                <%@ page import="model.*" %>
                    <%@ page import="dao.*" %>

                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>My Webcrumbs Plugin</title>
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
                                    background: #ffffff;
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

                                #webcrumbs .left-4 {
                                    left: 16px;
                                }

                                #webcrumbs .top-4 {
                                    top: 16px;
                                }

                                #webcrumbs .col-span-2 {
                                    grid-column: span 2 / span 2;
                                }

                                #webcrumbs .mb-2 {
                                    margin-bottom: 8px;
                                }

                                #webcrumbs .mb-3 {
                                    margin-bottom: 12px;
                                }

                                #webcrumbs .mb-4 {
                                    margin-bottom: 16px;
                                }

                                #webcrumbs .mb-6 {
                                    margin-bottom: 24px;
                                }

                                #webcrumbs .mr-1 {
                                    margin-right: 4px;
                                }

                                #webcrumbs .mt-2 {
                                    margin-top: 8px;
                                }

                                #webcrumbs .block {
                                    display: block;
                                }

                                #webcrumbs .flex {
                                    display: flex;
                                }

                                #webcrumbs .inline-flex {
                                    display: inline-flex;
                                }

                                #webcrumbs .grid {
                                    display: grid;
                                }

                                #webcrumbs .h-\[200px\] {
                                    height: 200px;
                                }

                                #webcrumbs .w-\[1200px\] {
                                    width: 1200px;
                                }

                                #webcrumbs .w-\[250px\] {
                                    width: 250px;
                                }

                                #webcrumbs .w-\[300px\] {
                                    width: 300px;
                                }

                                #webcrumbs .w-full {
                                    width: 100%;
                                }

                                #webcrumbs .flex-1 {
                                    flex: 1 1 0%;
                                }

                                #webcrumbs .grid-cols-2 {
                                    grid-template-columns: repeat(2, minmax(0, 1fr));
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

                                #webcrumbs .gap-1 {
                                    gap: 4px;
                                }

                                #webcrumbs .gap-12 {
                                    gap: 48px;
                                }

                                #webcrumbs .gap-2 {
                                    gap: 8px;
                                }

                                #webcrumbs .gap-4 {
                                    gap: 16px;
                                }

                                #webcrumbs .gap-6 {
                                    gap: 24px;
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

                                #webcrumbs .bg-blue-600 {
                                    --tw-bg-opacity: 1;
                                    background-color: rgb(37 99 235 / var(--tw-bg-opacity));
                                }

                                #webcrumbs .bg-gray-100 {
                                    --tw-bg-opacity: 1;
                                    background-color: rgb(243 244 246 / var(--tw-bg-opacity));
                                }

                                #webcrumbs .bg-gray-50 {
                                    --tw-bg-opacity: 1;
                                    background-color: rgb(249 250 251 / var(--tw-bg-opacity));
                                }

                                #webcrumbs .bg-red-500 {
                                    --tw-bg-opacity: 1;
                                    background-color: rgb(239 68 68 / var(--tw-bg-opacity));
                                }

                                #webcrumbs .bg-sky-500 {
                                    --tw-bg-opacity: 1;
                                    background-color: rgb(14 165 233 / var(--tw-bg-opacity));
                                }

                                #webcrumbs .bg-white\/90 {
                                    background-color: hsla(0, 0%, 100%, 0.9);
                                }

                                #webcrumbs .object-cover {
                                    object-fit: cover;
                                }

                                #webcrumbs .p-2 {
                                    padding: 8px;
                                }

                                #webcrumbs .p-4 {
                                    padding: 16px;
                                }

                                #webcrumbs .p-8 {
                                    padding: 32px;
                                }

                                #webcrumbs .px-3 {
                                    padding-left: 12px;
                                    padding-right: 12px;
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

                                #webcrumbs .py-4 {
                                    padding-bottom: 16px;
                                    padding-top: 16px;
                                }

                                #webcrumbs .text-center {
                                    text-align: center;
                                }

                                #webcrumbs .font-sans {
                                    font-family:
                                        Poppins,
                                        ui-sans-serif,
                                        system-ui,
                                        sans-serif,
                                        Apple Color Emoji,
                                        Segoe UI Emoji,
                                        Segoe UI Symbol,
                                        Noto Color Emoji;
                                }

                                #webcrumbs .text-2xl {
                                    font-size: 24px;
                                    line-height: 31.200000000000003px;
                                }

                                #webcrumbs .text-base {
                                    font-size: 16px;
                                    line-height: 25.6px;
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

                                #webcrumbs .font-medium {
                                    font-weight: 500;
                                }

                                #webcrumbs .not-italic {
                                    font-style: normal;
                                }

                                #webcrumbs .text-blue-600 {
                                    --tw-text-opacity: 1;
                                    color: rgb(37 99 235 / var(--tw-text-opacity));
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

                                #webcrumbs .text-rose-500 {
                                    --tw-text-opacity: 1;
                                    color: rgb(244 63 94 / var(--tw-text-opacity));
                                }

                                #webcrumbs .text-sky-500 {
                                    --tw-text-opacity: 1;
                                    color: rgb(14 165 233 / var(--tw-text-opacity));
                                }

                                #webcrumbs .text-white {
                                    --tw-text-opacity: 1;
                                    color: rgb(255 255 255 / var(--tw-text-opacity));
                                }

                                #webcrumbs .shadow-sm {
                                    --tw-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                                    --tw-shadow-colored: 0 1px 2px 0 var(--tw-shadow-color);
                                    box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),
                                        var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
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

                                #webcrumbs .hover\:border-sky-500:hover {
                                    --tw-border-opacity: 1;
                                    border-color: rgb(14 165 233 / var(--tw-border-opacity));
                                }

                                #webcrumbs .hover\:bg-blue-700:hover {
                                    --tw-bg-opacity: 1;
                                    background-color: rgb(29 78 216 / var(--tw-bg-opacity));
                                }

                                #webcrumbs .hover\:bg-gray-50:hover {
                                    --tw-bg-opacity: 1;
                                    background-color: rgb(249 250 251 / var(--tw-bg-opacity));
                                }

                                #webcrumbs .hover\:bg-red-600:hover {
                                    --tw-bg-opacity: 1;
                                    background-color: rgb(220 38 38 / var(--tw-bg-opacity));
                                }

                                #webcrumbs .hover\:bg-white:hover {
                                    --tw-bg-opacity: 1;
                                    background-color: rgb(255 255 255 / var(--tw-bg-opacity));
                                }

                                #webcrumbs .hover\:text-\[\#1877F2\]:hover {
                                    --tw-text-opacity: 1;
                                    color: rgb(24 119 242 / var(--tw-text-opacity));
                                }

                                #webcrumbs .hover\:text-\[\#1DA1F2\]:hover {
                                    --tw-text-opacity: 1;
                                    color: rgb(29 161 242 / var(--tw-text-opacity));
                                }

                                #webcrumbs .hover\:text-\[\#E4405F\]:hover {
                                    --tw-text-opacity: 1;
                                    color: rgb(228 64 95 / var(--tw-text-opacity));
                                }

                                #webcrumbs .hover\:text-black:hover {
                                    --tw-text-opacity: 1;
                                    color: rgb(0 0 0 / var(--tw-text-opacity));
                                }

                                #webcrumbs .hover\:text-blue-700:hover {
                                    --tw-text-opacity: 1;
                                    color: rgb(29 78 216 / var(--tw-text-opacity));
                                }

                                #webcrumbs .hover\:text-sky-500:hover {
                                    --tw-text-opacity: 1;
                                    color: rgb(14 165 233 / var(--tw-text-opacity));
                                }

                                #webcrumbs .hover\:underline:hover {
                                    text-decoration-line: underline;
                                }

                                #webcrumbs .hover\:shadow-lg:hover {
                                    --tw-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1),
                                        0 4px 6px -4px rgba(0, 0, 0, 0.1);
                                    --tw-shadow-colored: 0 10px 15px -3px var(--tw-shadow-color),
                                        0 4px 6px -4px var(--tw-shadow-color);
                                    box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),
                                        var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
                                }

                                #webcrumbs .focus\:outline-none:focus {
                                    outline: 2px solid transparent;
                                    outline-offset: 2px;
                                }

                                #webcrumbs .focus\:ring-2:focus {
                                    --tw-ring-offset-shadow: var(--tw-ring-inset) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color);
                                    --tw-ring-shadow: var(--tw-ring-inset) 0 0 0 calc(2px + var(--tw-ring-offset-width)) var(--tw-ring-color);
                                    box-shadow: var(--tw-ring-offset-shadow), var(--tw-ring-shadow),
                                        var(--tw-shadow, 0 0 #0000);
                                }

                                #webcrumbs .focus\:ring-sky-500:focus {
                                    --tw-ring-opacity: 1;
                                    --tw-ring-color: rgb(14 165 233 / var(--tw-ring-opacity));
                                }

                                #webcrumbs :is(.group:hover .group-hover\:scale-105) {
                                    --tw-scale-x: 1.05;
                                    --tw-scale-y: 1.05;
                                    transform: translate(var(--tw-translate-x), var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y));
                                }
                            </style>
                        </head>

                        <body>
                            <% List<Tour> tours = (List<Tour>) request.getAttribute("tours");
                                    int currentPage = (Integer) request.getAttribute("currentPage");
                                    int totalTours = (Integer) request.getAttribute("totalTours");
                                    int totalPages = (Integer) request.getAttribute("totalPages");

                                    TourDAO tourDAO = new TourDAO();
                                    String[] selectedPrices = request.getParameterValues("price");
                                    String[] selectedCategoriesStr = request.getParameterValues("category");

                                    // Convert category IDs to List<Integer>
                                        List<Integer> categoryIds = new ArrayList<>();
                                                if(selectedCategoriesStr != null) {
                                                for(String categoryId : selectedCategoriesStr) {
                                                try {
                                                categoryIds.add(Integer.parseInt(categoryId));
                                                } catch(NumberFormatException e) {
                                                // Skip invalid numbers
                                                }
                                                }
                                                }
                                                %>
                                                <div id="webcrumbs">
                                                    <div class="w-full font-sans">
                                                        <header
                                                            class="bg-sky-500 flex justify-between items-center py-2 px-4 text-white text-sm w-full">
                                                            <div class="flex items-center">
                                                                <span class="material-symbols-outlined mr-1">call</span>
                                                                <span>1900 1839 - Từ 8:00 - 11:00 hàng ngày</span>
                                                            </div>
                                                            <div>
                                                                <a href="./login" class="hover:underline">Đăng nhập/Đăng
                                                                    ký</a>
                                                            </div>
                                                        </header>
                                                        <nav class="py-4 px-8">
                                                            <div class="flex justify-center items-center">
                                                                <a href="./home.jsp" class="flex items-center">
                                                                    <img src="./image/logo.svg" alt="TourNest Logo"
                                                                        style="height: 100px; width: auto;" />
                                                                </a>
                                                            </div>
                                                            <p class="text-center mt-2">Hãy đến và trải nghiệm những
                                                                dịch vụ tour du lịch của Tour<span
                                                                    class="text-sky-500">Nest</span></p>
                                                        </nav>
                                                        <div class="flex gap-6 p-8 max-w-[1200px] mx-auto">
                                                            <div class="w-[250px]">
                                                                <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                                                                    <h3 class="font-medium mb-4">Bộ lọc tìm kiếm</h3>
                                                                    <form action="tour" method="GET" class="space-y-4">
                                                                        <!-- Search by name -->
                                                                        <div class="mb-4">
                                                                            <input type="text" name="search"
                                                                                placeholder="Tìm kiếm tour..."
                                                                                value="${param.search}"
                                                                                class="w-full border p-2 rounded" />
                                                                        </div>

                                                                        <!-- Price range -->
                                                                        <div class="grid grid-cols-2 gap-2">
                                                                            <label class="flex items-center space-x-2">
                                                                                <input type="checkbox" name="price"
                                                                                    value="0" <%=selectedPrices !=null
                                                                                    &&
                                                                                    Arrays.asList(selectedPrices).contains("0")
                                                                                    ? "checked" : "" %>/>
                                                                                <span>Dưới 5 triệu</span>
                                                                            </label>
                                                                            <label class="flex items-center space-x-2">
                                                                                <input type="checkbox" name="price"
                                                                                    value="5" <%=selectedPrices
                                                                                    !=null &&
                                                                                    Arrays.asList(selectedPrices).contains("5")
                                                                                    ? "checked" : "" %>/>
                                                                                <span>5-10 triệu</span>
                                                                            </label>
                                                                            <label class="flex items-center space-x-2">
                                                                                <input type="checkbox" name="price"
                                                                                    value="10" <%=selectedPrices
                                                                                    !=null &&
                                                                                    Arrays.asList(selectedPrices).contains("10")
                                                                                    ? "checked" : "" %>/>
                                                                                <span>10-20 triệu</span>
                                                                            </label>
                                                                            <label class="flex items-center space-x-2">
                                                                                <input type="checkbox" name="price"
                                                                                    value="20" <%=selectedPrices
                                                                                    !=null &&
                                                                                    Arrays.asList(selectedPrices).contains("20")
                                                                                    ? "checked" : "" %>/>
                                                                                <span>Trên 20 triệu</span>
                                                                            </label>
                                                                        </div>

                                                                        <!-- Region -->
                                                                        <select name="region"
                                                                            class="w-full border p-2 rounded">
                                                                            <option value="" ${empty param.region
                                                                                ? 'selected' : '' }>Tất cả khu vực
                                                                            </option>
                                                                            <% for(String region :
                                                                                tourDAO.getAllRegions()) { %>
                                                                                <option value="<%= region %>"
                                                                                    <%=region.equals(request.getParameter("region"))
                                                                                    ? "selected" : "" %>>
                                                                                    <%= region %>
                                                                                </option>
                                                                                <% } %>
                                                                        </select>

                                                                        <!-- Điểm khởi hành -->
                                                                        <div class="mb-4">
                                                                            <label
                                                                                class="block text-sm font-medium mb-2">Điểm
                                                                                khởi hành</label>
                                                                            <select name="departure"
                                                                                class="w-full border p-2 rounded">
                                                                                <option value="" ${empty param.departure
                                                                                    ? 'selected' : '' }>Tất cả</option>
                                                                                <% List<City> cities =
                                                                                    tourDAO.getAllCities();
                                                                                    for(City city : cities) {
                                                                                    %>
                                                                                    <option value="<%= city.getId() %>"
                                                                                        <%=String.valueOf(city.getId()).equals(request.getParameter("departure"))
                                                                                        ? "selected" : "" %>>
                                                                                        <%= city.getName() %>
                                                                                    </option>
                                                                                    <% } %>
                                                                            </select>
                                                                        </div>

                                                                        <!-- Điểm đến -->
                                                                        <div class="mb-4">
                                                                            <label
                                                                                class="block text-sm font-medium mb-2">Điểm
                                                                                đến</label>
                                                                            <select name="destination"
                                                                                class="w-full border p-2 rounded">
                                                                                <option value="" ${empty
                                                                                    param.destination ? 'selected' : ''
                                                                                    }>Tất cả</option>
                                                                                <% for(City city : cities) { %>
                                                                                    <option value="<%= city.getId() %>"
                                                                                        <%=String.valueOf(city.getId()).equals(request.getParameter("destination"))
                                                                                        ? "selected" : "" %>>
                                                                                        <%= city.getName() %>
                                                                                    </option>
                                                                                    <% } %>
                                                                            </select>
                                                                        </div>

                                                                        <!-- Ngày đi -->
                                                                        <div class="mb-4">
                                                                            <label
                                                                                class="block text-sm font-medium mb-2">Ngày
                                                                                đi</label>
                                                                            <input type="date" name="date"
                                                                                value="${param.date}"
                                                                                class="w-full border p-2 rounded" />
                                                                        </div>

                                                                        <!-- Phù hợp với -->
                                                                        <div class="mb-4">
                                                                            <label
                                                                                class="block text-sm font-medium mb-2">Phù
                                                                                hợp với</label>
                                                                            <select name="suitable"
                                                                                class="w-full border p-2 rounded">
                                                                                <option value="" ${empty param.suitable
                                                                                    ? 'selected' : '' }>Tất cả</option>
                                                                                <% List<String> suitables =
                                                                                    tourDAO.getAllSuitableFor();
                                                                                    for(String suitable : suitables) {
                                                                                    %>
                                                                                    <option value="<%= suitable %>"
                                                                                        <%=suitable.equals(request.getParameter("suitable"))
                                                                                        ? "selected" : "" %>>
                                                                                        <%= suitable %>
                                                                                    </option>
                                                                                    <% } %>
                                                                            </select>
                                                                        </div>

                                                                        <!-- Dòng tour -->
                                                                        <div class="mb-4">
                                                                            <label
                                                                                class="block text-sm font-medium mb-2">Dòng
                                                                                tour</label>
                                                                            <div class="grid grid-cols-2 gap-2">
                                                                                <% List<Category> categories =
                                                                                    tourDAO.getAllCategories();
                                                                                    for(Category category : categories)
                                                                                    {
                                                                                    %>
                                                                                    <label
                                                                                        class="flex items-center space-x-2">
                                                                                        <input type="checkbox"
                                                                                            name="category"
                                                                                            value="<%= category.getId() %>"
                                                                                            <%=categoryIds !=null &&
                                                                                            categoryIds.contains(category.getId())
                                                                                            ? "checked" : "" %>/>
                                                                                        <span>
                                                                                            <%= category.getName() %>
                                                                                        </span>
                                                                                    </label>
                                                                                    <% } %>
                                                                            </div>
                                                                        </div>

                                                                        <button type="submit"
                                                                            class="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700">
                                                                            Áp dụng
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                            <div class="flex-1">
                                                                <div class="flex items-center justify-between mb-6">
                                                                    <p class="text-sm">Chúng tôi tìm thấy <span
                                                                            class="font-bold">
                                                                            <%= request.getAttribute("totalTours")
                                                                                !=null ?
                                                                                request.getAttribute("totalTours") : 0
                                                                                %>
                                                                        </span> chương trình tour</p>
                                                                    <form id="sortForm" action="tour" method="GET">
                                                                        <!-- Copy all current filter parameters -->
                                                                        <% if(request.getParameter("search") != null) { %>
                                                                            <input type="hidden" name="search" value="<%= request.getParameter("search") %>">
                                                                        <% } %>
                                                                        
                                                                        <% if(selectedPrices != null) {
                                                                            for(String price : selectedPrices) { %>
                                                                                <input type="hidden" name="price" value="<%= price %>">
                                                                            <% }
                                                                        } %>
                                                                        
                                                                        <% if(request.getParameter("region") != null) { %>
                                                                            <input type="hidden" name="region" value="<%= request.getParameter("region") %>">
                                                                        <% } %>
                                                                        
                                                                        <% if(request.getParameter("departure") != null) { %>
                                                                            <input type="hidden" name="departure" value="<%= request.getParameter("departure") %>">
                                                                        <% } %>
                                                                        
                                                                        <% if(request.getParameter("destination") != null) { %>
                                                                            <input type="hidden" name="destination" value="<%= request.getParameter("destination") %>">
                                                                        <% } %>
                                                                        
                                                                        <% if(request.getParameter("date") != null) { %>
                                                                            <input type="hidden" name="date" value="<%= request.getParameter("date") %>">
                                                                        <% } %>
                                                                        
                                                                        <% if(request.getParameter("suitable") != null) { %>
                                                                            <input type="hidden" name="suitable" value="<%= request.getParameter("suitable") %>">
                                                                        <% } %>
                                                                        
                                                                        <% if(request.getParameterValues("category") != null) {
                                                                            String[] selectedCategoryValues = request.getParameterValues("category");
                                                                            for(String category : selectedCategoryValues) { %>
                                                                                <input type="hidden" name="category" value="<%= category %>">
                                                                            <% }
                                                                        } %>
                                                                        
                                                                        <select name="sort"
                                                                            class="border p-2 rounded hover:border-sky-500 focus:ring-2 focus:ring-sky-500 focus:outline-none transition"
                                                                            onchange="this.form.submit()">
                                                                            <option value="default" ${param.sort==null ||
                                                                                param.sort=='default' ? 'selected' : '' }>
                                                                                Mặc định</option>
                                                                            <option value="price_asc"
                                                                                ${param.sort=='price_asc' ? 'selected' : ''
                                                                                }>Giá thấp đến cao</option>
                                                                            <option value="price_desc"
                                                                                ${param.sort=='price_desc' ? 'selected' : ''
                                                                                }>Giá cao đến thấp</option>
                                                                            <option value="duration"
                                                                                ${param.sort=='duration' ? 'selected' : ''
                                                                                }>Thời gian tour</option>
                                                                        </select>
                                                                    </form>
                                                                </div>

                                                                <div class="space-y-4">
                                                                    <% for(Tour tour : tours) { List<String>
                                                                        departureDates =
                                                                        tourDAO.getDepartureDates(tour.getId());
                                                                        %>
                                                                        <div
                                                                            class="border rounded-lg overflow-hidden hover:shadow-lg transition group">
                                                                            <div class="flex">
                                                                                <div class="w-[300px] relative">
                                                                                    <img src="<%= tour.getImg() %>"
                                                                                        class="w-full h-[200px] object-cover group-hover:scale-105 transition duration-500" />
                                                                                    <button
                                                                                        class="absolute top-4 left-4 bg-white/90 p-2 rounded-full hover:bg-white transition">
                                                                                        <span
                                                                                            class="material-symbols-outlined text-rose-500">favorite</span>
                                                                                    </button>
                                                                                </div>
                                                                                <div class="flex-1 p-4">
                                                                                    <h3
                                                                                        class="font-medium text-blue-600 hover:text-blue-700 mb-3">
                                                                                        <%= tour.getName() %>
                                                                                    </h3>
                                                                                    <div
                                                                                        class="flex items-center gap-4 text-sm mb-3">
                                                                                        <span
                                                                                            class="flex items-center gap-1">
                                                                                            <span
                                                                                                class="material-symbols-outlined text-base">confirmation_number</span>
                                                                                            Mã tour: <%= tour.getId() %>
                                                                                        </span>
                                                                                        <span
                                                                                            class="flex items-center gap-1">
                                                                                            <span
                                                                                                class="material-symbols-outlined text-base">schedule</span>
                                                                                            Thời gian: <%=
                                                                                                tour.getDuration() %>
                                                                                        </span>
                                                                                        <span
                                                                                            class="flex items-center gap-1">
                                                                                            <span
                                                                                                class="material-symbols-outlined text-base">flight_takeoff</span>
                                                                                            Khởi hành: <%=
                                                                                                tour.getDepartureCity()
                                                                                                %>
                                                                                        </span>
                                                                                    </div>
                                                                                    <div class="flex gap-2 mb-4">
                                                                                        <% for(String date :
                                                                                            departureDates) { %>
                                                                                            <span
                                                                                                class="px-3 py-1 bg-gray-100 text-xs rounded-full">
                                                                                                <%= date %>
                                                                                            </span>
                                                                                            <% } %>
                                                                                    </div>
                                                                                    <div
                                                                                        class="flex items-center justify-between">
                                                                                        <div>
                                                                                            <p class="text-sm">Giá từ:
                                                                                            </p>
                                                                                            <p
                                                                                                class="font-bold text-red-500">
                                                                                                <%= String.format("%,.0f",
                                                                                                    tour.getPriceAdult())
                                                                                                    %> đ
                                                                                            </p>
                                                                                        </div>
                                                                                        <a href="tour-detail?id=<%= tour.getId() %>"
                                                                                            class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 transition">
                                                                                            Xem chi tiết
                                                                                        </a>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <% } %>
                                                                </div>

                                                                <div class="flex justify-center items-center space-x-1 mt-8">
                                                                    <% if(currentPage > 1) { %>
                                                                        <a href="?page=<%= currentPage - 1 %>&<%= request.getQueryString() != null ? request.getQueryString().replaceAll("&?page=\\d+", "") : "" %>" 
                                                                           class="px-4 py-2 text-gray-500 bg-white hover:bg-blue-50 border border-gray-300 rounded-lg transition duration-200 ease-in-out flex items-center gap-1">
                                                                            <i class="fas fa-chevron-left text-sm"></i>
                                                                            <span class="hidden sm:inline">Trước</span>
                                                                        </a>
                                                                        <% } else { %>
                                                                            <button disabled
                                                                                class="px-4 py-2 text-gray-400 bg-gray-100 border border-gray-300 rounded-lg cursor-not-allowed flex items-center gap-1">
                                                                                <i
                                                                                    class="fas fa-chevron-left text-sm"></i>
                                                                                <span
                                                                                    class="hidden sm:inline">Trước</span>
                                                                            </button>
                                                                            <% } %>

                                                                                <div class="hidden md:flex space-x-1">
                                                                                    <% int startPage=Math.max(1,
                                                                                        currentPage - 2); int
                                                                                        endPage=Math.min(totalPages,
                                                                                        currentPage + 2); if (startPage>
                                                                                        1) { %>
                                                                                        <a href="?page=1&<%= request.getQueryString() != null ? request.getQueryString().replaceAll("&?page=\\d+", "") : "" %>"
                                                                                            class="px-4 py-2 text-gray-500 bg-white hover:bg-blue-50 border border-gray-300 rounded-lg transition duration-200">
                                                                                            1
                                                                                        </a>
                                                                                        <% if (startPage> 2) { %>
                                                                                            <span
                                                                                                class="px-4 py-2 text-gray-500">...</span>
                                                                                            <% } %>
                                                                                                <% } %>

                                                                                                    <% for(int
                                                                                                        i=startPage; i
                                                                                                        <=endPage; i++)
                                                                                                        { %>
                                                                                                        <a href="?page=<%= i %>&<%= request.getQueryString() != null ? request.getQueryString().replaceAll("&?page=\\d+", "") : "" %>"
                                                                                                            class="px-4 py-2 <%= currentPage == i 
                                        ? " bg-blue-500 text-white border-blue-500" : "text-gray-500 bg-white hover:bg-blue-50 border-gray-300"
                                                                                                            %>
                                                                                                            border
                                                                                                            rounded-lg
                                                                                                            transition
                                                                                                            duration-200">
                                                                                                            <%= i %>
                                                                                                        </a>
                                                                                                        <% } %>

                                                                                                            <% if
                                                                                                                (endPage
                                                                                                                <
                                                                                                                totalPages)
                                                                                                                { %>
                                                                                                                <% if
                                                                                                                    (endPage
                                                                                                                    <
                                                                                                                    totalPages
                                                                                                                    - 1)
                                                                                                                    { %>
                                                                                                                    <span
                                                                                                                        class="px-4 py-2 text-gray-500">...</span>
                                                                                                                    <% }
                                                                                                                        %>
                                                                                                                        <a href="?page=<%= totalPages %>&<%= request.getQueryString() != null ? request.getQueryString().replaceAll("&?page=\\d+", "") : "" %>"
                                                                                                                            class="px-4 py-2 text-gray-500 bg-white hover:bg-blue-50 border border-gray-300 rounded-lg transition duration-200">
                                                                                                                            <%= totalPages
                                                                                                                                %>
                                                                                                                        </a>
                                                                                                                        <% }
                                                                                                                            %>
                                                                                </div>

                                                                                <span
                                                                                    class="md:hidden px-4 py-2 text-sm text-gray-500">
                                                                                    Trang <%= currentPage %> / <%=
                                                                                            totalPages %>
                                                                                </span>

                                                                                <% if(currentPage < totalPages) { %>
                                                                                    <a href="?page=<%= currentPage + 1 %>&<%= request.getQueryString() != null ? request.getQueryString().replaceAll("&?page=\\d+", "") : "" %>"
                                                                                        class="px-4 py-2 text-gray-500 bg-white hover:bg-blue-50 border border-gray-300 rounded-lg transition duration-200 ease-in-out flex items-center gap-1">
                                                                                        <span
                                                                                            class="hidden sm:inline">Tiếp</span>
                                                                                        <i
                                                                                            class="fas fa-chevron-right text-sm"></i>
                                                                                    </a>
                                                                                    <% } else { %>
                                                                                        <button disabled
                                                                                            class="px-4 py-2 text-gray-400 bg-gray-100 border border-gray-300 rounded-lg cursor-not-allowed flex items-center gap-1">
                                                                                            <span
                                                                                                class="hidden sm:inline">Tiếp</span>
                                                                                            <i
                                                                                                class="fas fa-chevron-right text-sm"></i>
                                                                                        </button>
                                                                                        <% } %>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <footer class="bg-gray-50 px-8 py-12 w-full">
                                                            <div class="grid grid-cols-4 gap-12 max-w-[1200px] mx-auto">
                                                                <div>
                                                                    <h2 class="text-2xl font-bold mb-4">Tour<span
                                                                            class="text-sky-500">Nest</span></h2>
                                                                    <p class="text-sm text-gray-600 mb-4">Best Travel
                                                                        Agency</p>
                                                                    <div class="flex gap-4"> <a href="#"
                                                                            class="text-gray-400 hover:text-[#1877F2] transition">
                                                                            <i
                                                                                class="fa-brands fa-facebook text-xl"></i>
                                                                        </a> <a href="#"
                                                                            class="text-gray-400 hover:text-[#1DA1F2] transition">
                                                                            <i class="fa-brands fa-twitter text-xl"></i>
                                                                        </a> <a href="#"
                                                                            class="text-gray-400 hover:text-[#E4405F] transition">
                                                                            <i
                                                                                class="fa-brands fa-instagram text-xl"></i>
                                                                        </a> <a href="#"
                                                                            class="text-gray-400 hover:text-black transition">
                                                                            <i class="fa-brands fa-tiktok text-xl"></i>
                                                                        </a> </div>
                                                                </div>
                                                                <div>
                                                                    <h3 class="font-medium mb-4">Liên hệ</h3>
                                                                    <address
                                                                        class="not-italic text-sm text-gray-600 space-y-2">
                                                                        <p>KCNC Hòa Lạc - Thạch Thất - Hà Nội</p>
                                                                        <p>(+84)834197845</p>
                                                                        <p>info@vietravel.com</p>
                                                                    </address>
                                                                </div>
                                                                <div>
                                                                    <h3 class="font-medium mb-4">Thông tin</h3>
                                                                    <ul class="text-sm text-gray-600 space-y-2">
                                                                        <li> <a href="#"
                                                                                class="hover:text-sky-500 transition">Tin
                                                                                tức</a> </li>
                                                                        <li> <a href="#"
                                                                                class="hover:text-sky-500 transition">Trợ
                                                                                giúp</a> </li>
                                                                        <li> <a href="#"
                                                                                class="hover:text-sky-500 transition">Chính
                                                                                sách bảo mật</a> </li>
                                                                        <li> <a href="#"
                                                                                class="hover:text-sky-500 transition">Điều
                                                                                khoản sử dụng</a> </li>
                                                                        <li> <a href="#"
                                                                                class="hover:text-sky-500 transition">Chính
                                                                                sách bảo vệ dữ liệu cá nhân</a>
                                                                        </li>
                                                                    </ul>
                                                                </div>
                                                                <div>
                                                                    <h3 class="font-medium mb-4">Liên hệ ngay</h3> <a
                                                                        href="tel:19001839"
                                                                        class="inline-flex items-center gap-2 bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 transition">
                                                                        <span
                                                                            class="material-symbols-outlined">call</span>
                                                                        1900 1839 </a>
                                                                </div>
                                                            </div>
                                                        </footer>
                                                    </div>
                                                </div>

                                                <% if (request.getAttribute("errorMessage") !=null) { %>
                                                    <div
                                                        class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
                                                        <%= request.getAttribute("errorMessage") %>
                                                    </div>
                                                    <% } %>
                        </body>

                        </html>