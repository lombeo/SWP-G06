<%-- 
    Document   : login
    Created on : Feb 25, 2025, 3:20:53 PM
    Author     : Lom
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Webcrumbs Plugin</title>
    <style>
        @import url(https://fonts.googleapis.com/css2?family=Poppins&display=swap);

        @import url(https://fonts.googleapis.com/css2?family=Roboto&display=swap);

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

        #webcrumbs .inset-0 {
            inset: 0;
        }

        #webcrumbs .mb-6 {
            margin-bottom: 24px;
        }

        #webcrumbs .ml-2 {
            margin-left: 8px;
        }

        #webcrumbs .mr-2 {
            margin-right: 8px;
        }

        #webcrumbs .mt-2 {
            margin-top: 8px;
        }

        #webcrumbs .flex {
            display: flex;
        }

        #webcrumbs .grid {
            display: grid;
        }

        #webcrumbs .h-4 {
            height: 16px;
        }

        #webcrumbs .h-full {
            height: 100%;
        }

        #webcrumbs .w-1\/2 {
            width: 50%;
        }

        #webcrumbs .w-4 {
            width: 16px;
        }

        #webcrumbs .w-\[800px\] {
            width: 800px;
        }

        #webcrumbs .w-full {
            width: 100%;
        }

        #webcrumbs .grid-cols-2 {
            grid-template-columns: repeat(2, minmax(0, 1fr));
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

        #webcrumbs .gap-4 {
            gap: 16px;
        }

        #webcrumbs :is(.space-y-4 > :not([hidden]) ~ :not([hidden])) {
            --tw-space-y-reverse: 0;
            margin-bottom: calc(16px * var(--tw-space-y-reverse));
            margin-top: calc(16px * (1 - var(--tw-space-y-reverse)));
        }

        #webcrumbs .overflow-hidden {
            overflow: hidden;
        }

        #webcrumbs .rounded-lg {
            border-radius: 24px;
        }

        #webcrumbs .border {
            border-width: 1px;
        }

        #webcrumbs .border-gray-300 {
            --tw-border-opacity: 1;
            border-color: rgb(209 213 219 / var(--tw-border-opacity));
        }

        #webcrumbs .bg-blue-600 {
            --tw-bg-opacity: 1;
            background-color: rgb(37 99 235 / var(--tw-bg-opacity));
        }

        #webcrumbs .bg-white {
            --tw-bg-opacity: 1;
            background-color: rgb(255 255 255 / var(--tw-bg-opacity));
        }

        #webcrumbs .bg-gradient-to-br {
            background-image: linear-gradient(to bottom right, var(--tw-gradient-stops));
        }

        #webcrumbs .from-blue-400 {
            --tw-gradient-from: #60a5fa var(--tw-gradient-from-position);
            --tw-gradient-to: rgba(96, 165, 250, 0) var(--tw-gradient-to-position);
            --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to);
        }

        #webcrumbs .to-blue-600 {
            --tw-gradient-to: #2563eb var(--tw-gradient-to-position);
        }

        #webcrumbs .object-cover {
            object-fit: cover;
        }

        #webcrumbs .p-12 {
            padding: 48px;
        }

        #webcrumbs .p-8 {
            padding: 32px;
        }

        #webcrumbs .px-4 {
            padding-left: 16px;
            padding-right: 16px;
        }

        #webcrumbs .py-2 {
            padding-bottom: 8px;
            padding-top: 8px;
        }

        #webcrumbs .text-center {
            text-align: center;
        }

        #webcrumbs .text-2xl {
            font-size: 24px;
            line-height: 31.200000000000003px;
        }

        #webcrumbs .text-4xl {
            font-size: 36px;
            line-height: 41.4px;
        }

        #webcrumbs .text-5xl {
            font-size: 48px;
            line-height: 52.800000000000004px;
        }

        #webcrumbs .text-sm {
            font-size: 14px;
            line-height: 21px;
        }

        #webcrumbs .font-semibold {
            font-weight: 600;
        }

        #webcrumbs .italic {
            font-style: italic;
        }

        #webcrumbs .text-blue-500 {
            --tw-text-opacity: 1;
            color: rgb(59 130 246 / var(--tw-text-opacity));
        }

        #webcrumbs .text-blue-600 {
            --tw-text-opacity: 1;
            color: rgb(37 99 235 / var(--tw-text-opacity));
        }

        #webcrumbs .text-red-500 {
            --tw-text-opacity: 1;
            color: rgb(239 68 68 / var(--tw-text-opacity));
        }

        #webcrumbs .text-white {
            --tw-text-opacity: 1;
            color: rgb(255 255 255 / var(--tw-text-opacity));
        }

        #webcrumbs .opacity-50 {
            opacity: 0.5;
        }

        #webcrumbs .shadow-xl {
            --tw-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1),
                0 8px 10px -6px rgba(0, 0, 0, 0.1);
            --tw-shadow-colored: 0 20px 25px -5px var(--tw-shadow-color),
                0 8px 10px -6px var(--tw-shadow-color);
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

        #webcrumbs .duration-200 {
            transition-duration: 0.2s;
        }

        #webcrumbs {
            font-family: Roboto !important;
            font-size: 16px !important;
        }

        #webcrumbs .hover\:bg-blue-700:hover {
            --tw-bg-opacity: 1;
            background-color: rgb(29 78 216 / var(--tw-bg-opacity));
        }

        #webcrumbs .hover\:bg-gray-50:hover {
            --tw-bg-opacity: 1;
            background-color: rgb(249 250 251 / var(--tw-bg-opacity));
        }

        #webcrumbs .hover\:underline:hover {
            text-decoration-line: underline;
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

        #webcrumbs .focus\:ring-blue-500:focus {
            --tw-ring-opacity: 1;
            --tw-ring-color: rgb(59 130 246 / var(--tw-ring-opacity));
        }

        body {
            line-height: inherit;
            padding: 24px;
            display: flex;
            flex-direction: column;
            min-width: 100vw;
            min-height: 100vh;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #ffffff, #d4d4d4);
        }
    </style>
</head>

<body>
    <jsp:include page="components/header.jsp" />
    
    <div id="webcrumbs">
        <div class="w-[800px] flex bg-white rounded-lg overflow-hidden shadow-xl">
            <div class="w-1/2 relative">
                <div class="absolute inset-0 bg-gradient-to-br from-blue-400 to-blue-600"> <img
                        src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&amp;ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                        class="w-full h-full object-cover opacity-50" alt="Ocean background" /> </div>
                <div class="relative p-12 text-white">
                    <h1 class="font-serif text-4xl italic"> It&#x27;s time to </h1>
                    <h2 class="font-serif text-5xl italic mt-2"> TourNest </h2>
                </div>
            </div>
            <div class="w-1/2 p-8">
                <h3 class="text-2xl font-semibold mb-6">Đăng nhập</h3>
                <form class="space-y-4" action="login" method="POST">
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="text-red-500 text-sm text-center">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                    <div>
                        <input type="email" name="email" placeholder="Địa chỉ email"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" />
                    </div>
                    <div>
                        <input type="password" name="password" placeholder="Mật khẩu"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" />
                    </div>
                    <div class="flex items-center">
                        <input type="checkbox" name="remember" class="h-4 w-4 text-blue-500" />
                        <span class="ml-2 text-sm">Ghi nhớ mật khẩu</span>
                    </div>
                    <button type="submit"
                        class="w-full py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition duration-200">
                        Đăng nhập
                    </button>
                    <div class="text-center text-sm"> <span>hoặc đăng nhập với</span> </div>
                    <div class="grid grid-cols-2 gap-4"> <button
                            class="flex items-center justify-center py-2 px-4 border border-gray-300 rounded-lg hover:bg-gray-50 transition duration-200">
                            <i class="fa-brands fa-facebook text-blue-600 mr-2"></i> Facebook </button> <button
                            class="flex items-center justify-center py-2 px-4 border border-gray-300 rounded-lg hover:bg-gray-50 transition duration-200">
                            <i class="fa-brands fa-google text-red-500 mr-2"></i> Google </button> </div>
                    <div class="text-center text-sm"> <span>Bạn chưa có tài khoản? </span> <a href="./register"
                            class="text-blue-600 hover:underline">Đăng ký tại đây</a> </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="components/footer.jsp" />
</body>

</html>
