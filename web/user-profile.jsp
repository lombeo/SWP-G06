<%-- Document : user-profile Created on : Feb 25, 2025, 11:00:07 PM Author : Lom --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>User Profile - TourNest</title>
                <style>
                    @import url(https://fonts.googleapis.com/css2?family=Poppins&display=swap);

                    @import url(https://fonts.googleapis.com/css2?family=Roboto&display=swap);

                    @import url(https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200);

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

                    #webcrumbs .left-3 {
                        left: 12px;
                    }

                    #webcrumbs .top-3 {
                        top: 12px;
                    }

                    #webcrumbs .mb-4 {
                        margin-bottom: 16px;
                    }

                    #webcrumbs .mb-8 {
                        margin-bottom: 32px;
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

                    #webcrumbs .h-\[250px\] {
                        height: 250px;
                    }

                    #webcrumbs .min-h-screen {
                        min-height: 100vh;
                    }

                    #webcrumbs .w-\[250px\] {
                        width: 250px;
                    }

                    #webcrumbs .w-\[800px\] {
                        width: 800px;
                    }

                    #webcrumbs .w-full {
                        width: 100%;
                    }

                    #webcrumbs .max-w-3xl {
                        max-width: 48rem;
                    }

                    #webcrumbs .grid-cols-2 {
                        grid-template-columns: repeat(2, minmax(0, 1fr));
                    }

                    #webcrumbs .flex-row {
                        flex-direction: row;
                    }

                    #webcrumbs .flex-col {
                        flex-direction: column;
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

                    #webcrumbs .gap-8 {
                        gap: 32px;
                    }

                    #webcrumbs :is(.space-y-4 > :not([hidden]) ~ :not([hidden])) {
                        --tw-space-y-reverse: 0;
                        margin-bottom: calc(16px * var(--tw-space-y-reverse));
                        margin-top: calc(16px * (1 - var(--tw-space-y-reverse)));
                    }

                    #webcrumbs .rounded-full {
                        border-radius: 9999px;
                    }

                    #webcrumbs .rounded-lg {
                        border-radius: 24px;
                    }

                    #webcrumbs .rounded-xl {
                        border-radius: 36px;
                    }

                    #webcrumbs .border {
                        border-width: 1px;
                    }

                    #webcrumbs .border-2 {
                        border-width: 2px;
                    }

                    #webcrumbs .border-blue-500 {
                        --tw-border-opacity: 1;
                        border-color: rgb(59 130 246 / var(--tw-border-opacity));
                    }

                    #webcrumbs .border-blue-600 {
                        --tw-border-opacity: 1;
                        border-color: rgb(37 99 235 / var(--tw-border-opacity));
                    }

                    #webcrumbs .bg-blue-600 {
                        --tw-bg-opacity: 1;
                        background-color: rgb(37 99 235 / var(--tw-bg-opacity));
                    }

                    #webcrumbs .bg-white {
                        --tw-bg-opacity: 1;
                        background-color: rgb(255 255 255 / var(--tw-bg-opacity));
                    }

                    #webcrumbs .p-8 {
                        padding: 32px;
                    }

                    #webcrumbs .px-8 {
                        padding-left: 32px;
                        padding-right: 32px;
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

                    #webcrumbs .text-center {
                        text-align: center;
                    }

                    #webcrumbs .text-3xl {
                        font-size: 30px;
                        line-height: 36px;
                    }

                    #webcrumbs .text-8xl {
                        font-size: 96px;
                        line-height: 100.80000000000001px;
                    }

                    #webcrumbs .text-blue-500 {
                        --tw-text-opacity: 1;
                        color: rgb(59 130 246 / var(--tw-text-opacity));
                    }

                    #webcrumbs .text-blue-600 {
                        --tw-text-opacity: 1;
                        color: rgb(37 99 235 / var(--tw-text-opacity));
                    }

                    #webcrumbs .text-white {
                        --tw-text-opacity: 1;
                        color: rgb(255 255 255 / var(--tw-text-opacity));
                    }

                    #webcrumbs .shadow-lg {
                        --tw-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1),
                            0 4px 6px -4px rgba(0, 0, 0, 0.1);
                        --tw-shadow-colored: 0 10px 15px -3px var(--tw-shadow-color),
                            0 4px 6px -4px var(--tw-shadow-color);
                        box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),
                            var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
                    }

                    #webcrumbs .transition-colors {
                        transition-duration: 0.15s;
                        transition-property: color, background-color, border-color,
                            text-decoration-color, fill, stroke;
                        transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
                    }

                    #webcrumbs {
                        font-family: Roboto !important;
                        font-size: 16px !important;
                    }

                    #webcrumbs .hover\:border-blue-500:hover {
                        --tw-border-opacity: 1;
                        border-color: rgb(59 130 246 / var(--tw-border-opacity));
                    }

                    #webcrumbs .hover\:bg-blue-50:hover {
                        --tw-bg-opacity: 1;
                        background-color: rgb(239 246 255 / var(--tw-bg-opacity));
                    }

                    #webcrumbs .hover\:bg-blue-700:hover {
                        --tw-bg-opacity: 1;
                        background-color: rgb(29 78 216 / var(--tw-bg-opacity));
                    }

                    #webcrumbs .focus\:border-blue-500:focus {
                        --tw-border-opacity: 1;
                        border-color: rgb(59 130 246 / var(--tw-border-opacity));
                    }

                    #webcrumbs .focus\:outline-none:focus {
                        outline: 2px solid transparent;
                        outline-offset: 2px;
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

                    #changePasswordModal {
                        position: fixed;
                        top: 0;
                        right: 0;
                        bottom: 0;
                        left: 0;
                        background-color: rgba(0, 0, 0, 0.5);
                        display: none;
                        align-items: center;
                        justify-content: center;
                        z-index: 50;
                    }

                    #changePasswordModal>div {
                        background-color: #fff;
                        border-radius: 1.5rem;
                        padding: 2rem;
                        width: 100%;
                        max-width: 28rem;
                        position: relative;
                    }

                    #changePasswordModal input {
                        width: 100%;
                        padding: 0.5rem 1rem;
                        border: 1px solid #d1d5db;
                        border-radius: 9999px;
                        transition-property: border-color;
                        transition-duration: 0.15s;
                    }

                    #changePasswordModal input:hover,
                    #changePasswordModal input:focus {
                        border-color: #3b82f6;
                        outline: none;
                    }

                    #changePasswordModal button {
                        padding: 0.5rem 1.5rem;
                        border-radius: 9999px;
                        transition-property: background-color, color;
                        transition-duration: 0.15s;
                    }

                    #changePasswordModal .border-blue-600 {
                        border: 1px solid #2563eb;
                        color: #2563eb;
                    }

                    #changePasswordModal .bg-blue-600 {
                        background-color: #2563eb;
                        color: #fff;
                    }

                    #changePasswordModal .hover\:bg-blue-50:hover {
                        background-color: #eff6ff;
                    }

                    #changePasswordModal .hover\:bg-blue-700:hover {
                        background-color: #1d4ed8;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="components/header.jsp" />
                
                <div id="webcrumbs">
                    <div class="w-[800px] bg-blue-600 min-h-screen flex items-center justify-center p-8">
                        <div class="bg-white rounded-xl p-8 w-full max-w-3xl shadow-lg">
                            <h1 class="text-center text-3xl mb-8 font-cursive">TourNest - Thông tin cá nhân</h1>

                            <c:if test="${not empty success}">
                                <div
                                    class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4">
                                    ${success}
                                </div>
                            </c:if>

                            <c:if test="${not empty error}">
                                <div
                                    class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4">
                                    ${error}
                                </div>
                            </c:if>

                            <form action="user-profile" method="post" enctype="multipart/form-data"
                                class="grid grid-cols-2 gap-8">
                                <input type="hidden" name="action" value="update-profile">
                                <div class="space-y-4">
                                    <div class="relative">
                                        <span class="absolute left-3 top-3 text-blue-600">
                                            <span class="material-symbols-outlined">person</span>
                                        </span>
                                        <input type="text" name="fullName" value="${user.fullName}"
                                            placeholder="Tên khách hàng"
                                            class="w-full pl-10 pr-4 py-2 border rounded-full hover:border-blue-500 focus:border-blue-500 focus:outline-none transition-colors" />
                                    </div>
                                    <div class="relative">
                                        <span class="absolute left-3 top-3 text-blue-600">
                                            <span class="material-symbols-outlined">mail</span>
                                        </span>
                                        <input type="email" value="${user.email}" readonly
                                            class="w-full pl-10 pr-4 py-2 border rounded-full bg-gray-100" />
                                    </div>
                                    <div class="relative">
                                        <span class="absolute left-3 top-3 text-blue-600">
                                            <span class="material-symbols-outlined">phone</span>
                                        </span>
                                        <input type="tel" name="phone" value="${user.phone}" placeholder="Số điện thoại"
                                            class="w-full pl-10 pr-4 py-2 border rounded-full hover:border-blue-500 focus:border-blue-500 focus:outline-none transition-colors" />
                                    </div>
                                    <div class="relative">
                                        <span class="absolute left-3 top-3 text-blue-600">
                                            <span class="material-symbols-outlined">person</span>
                                        </span>
                                        <div class="w-full pl-10 pr-4 py-2 flex gap-4">
                                            <label class="inline-flex items-center">
                                                <input type="radio" name="gender" value="Nam" ${user.genderText=='Nam'
                                                    ? 'checked' : '' } class="form-radio text-blue-600">
                                                <span class="ml-2">Nam</span>
                                            </label>
                                            <label class="inline-flex items-center">
                                                <input type="radio" name="gender" value="Nữ" ${user.genderText=='Nữ'
                                                    ? 'checked' : '' } class="form-radio text-blue-600">
                                                <span class="ml-2">Nữ</span>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="relative">
                                        <span class="absolute left-3 top-3 text-blue-600">
                                            <span class="material-symbols-outlined">calendar_today</span>
                                        </span>
                                        <input type="date" name="dob" value="${user.dob}" placeholder="Ngày sinh"
                                            class="w-full pl-10 pr-4 py-2 border rounded-full hover:border-blue-500 focus:border-blue-500 focus:outline-none transition-colors" />
                                    </div>
                                    <div class="relative">
                                        <span class="absolute left-3 top-3 text-blue-600">
                                            <span class="material-symbols-outlined">location_on</span>
                                        </span>
                                        <input type="text" name="address" value="${user.address}" placeholder="Địa chỉ"
                                            class="w-full pl-10 pr-4 py-2 border rounded-full hover:border-blue-500 focus:border-blue-500 focus:outline-none transition-colors" />
                                    </div>
                                </div>
                                <div class="flex flex-col items-center justify-between">
                                    <div class="w-[250px] h-[250px] border-2 border-blue-500 rounded-lg flex items-center justify-center mb-4 relative overflow-hidden">
                                        <c:choose>
                                            <c:when test="${empty user.avatar}">
                                                <span class="material-symbols-outlined text-8xl text-blue-500">person</span>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${user.avatar}" alt="Avatar" class="w-full h-full object-cover">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <input type="file" name="avatar" id="avatar" style="display: none;" accept="image/*">
                                    <label for="avatar" class="bg-blue-600 text-white px-8 py-2 rounded-full hover:bg-blue-700 transition-colors cursor-pointer">
                                        Chọn ảnh
                                    </label>
                                </div>
                                <div class="col-span-2 flex justify-between mt-8">
                                    <button type="submit"
                                        class="bg-blue-600 text-white px-8 py-2 rounded-full hover:bg-blue-700 transition-colors">
                                        Lưu thông tin
                                    </button>
                                    <button type="button" onclick="showChangePasswordModal()"
                                        class="border border-blue-600 text-blue-600 px-8 py-2 rounded-full hover:bg-blue-50 transition-colors">
                                        Thay đổi mật khẩu
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <jsp:include page="components/footer.jsp" />

                <!-- Change Password Modal -->
                <div id="changePasswordModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
                    <div class="bg-white rounded-xl p-8 w-full max-w-md relative">
                        <button type="button" onclick="hideChangePasswordModal()" class="absolute top-4 right-4 text-gray-500 hover:text-gray-700">
                            <span class="material-symbols-outlined">close</span>
                        </button>
                        <h2 class="text-2xl mb-6">Thay đổi mật khẩu</h2>
                        <form action="user-profile" method="post" onsubmit="return validatePasswordForm()">
                            <input type="hidden" name="action" value="change-password">
                            <div class="space-y-4">
                                <div class="relative">
                                    <input type="password" name="currentPassword" placeholder="Mật khẩu hiện tại"
                                        class="w-full px-4 py-2 border rounded-full hover:border-blue-500 focus:border-blue-500 focus:outline-none transition-colors" required />
                                </div>
                                <div class="relative">
                                    <input type="password" name="newPassword" id="newPassword" placeholder="Mật khẩu mới"
                                        class="w-full px-4 py-2 border rounded-full hover:border-blue-500 focus:border-blue-500 focus:outline-none transition-colors" required />
                                </div>
                                <div class="relative">
                                    <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Xác nhận mật khẩu mới"
                                        class="w-full px-4 py-2 border rounded-full hover:border-blue-500 focus:border-blue-500 focus:outline-none transition-colors" required />
                                </div>
                            </div>
                            <div class="flex justify-end gap-4 mt-6">
                                <button type="button" onclick="hideChangePasswordModal()" class="border border-blue-600 text-blue-600 px-6 py-2 rounded-full hover:bg-blue-50 transition-colors">
                                    Hủy
                                </button>
                                <button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded-full hover:bg-blue-700 transition-colors">
                                    Xác nhận
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <script>
                    // Preview selected image before upload
                    document.getElementById('avatar').addEventListener('change', function (e) {
                        if (e.target.files && e.target.files[0]) {
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                // Update preview image
                                const previewContainer = document.querySelector('.w-[250px].h-[250px]');
                                previewContainer.innerHTML = '<img src="' + e.target.result + '" alt="Avatar Preview" class="w-full h-full object-cover">';

                                // Upload file
                                const form = new FormData();
                                form.append('action', 'update-avatar');
                                form.append('avatar', document.getElementById('avatar').files[0]);

                                fetch('user-profile', {
                                    method: 'POST',
                                    body: form
                                }).then(response => {
                                    if (response.ok) {
                                        window.location.reload();
                                    }
                                });
                            }
                            reader.readAsDataURL(e.target.files[0]);
                        }
                    });

                    // Password modal functions
                    function showChangePasswordModal() {
                        document.getElementById('changePasswordModal').style.display = 'flex';
                    }

                    function hideChangePasswordModal() {
                        document.getElementById('changePasswordModal').style.display = 'none';
                    }

                    function validatePasswordForm() {
                        const newPassword = document.getElementById('newPassword').value;
                        const confirmPassword = document.getElementById('confirmPassword').value;

                        if (newPassword !== confirmPassword) {
                            alert('Mật khẩu xác nhận không khớp');
                            return false;
                        }
                        return true;
                    }
                </script>
            </body>

            </html>