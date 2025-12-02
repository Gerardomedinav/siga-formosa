<x-app-interno-layout>
    <x-slot name="header">
        Módulo Asistencia
    </x-slot>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Tomar Asistencia -->
        <a href="{{ route('asistencias.registros') }}"
           class="block bg-white/20 backdrop-blur-md border border-white/30 shadow rounded-lg p-6 hover:bg-white/30 transition border-t-4 border-cyan-500">
            <h3 class="text-xl font-semibold text-white">Registros</h3>
            <p class="mt-2 text-sm text-gray-100">Tomar asistencia diaria.</p>
        </a>

        <!-- Reportes -->
        <a href="{{ route('asistencias.reportes') }}"
           class="block bg-white/20 backdrop-blur-md border border-white/30 shadow rounded-lg p-6 hover:bg-white/30 transition border-t-4 border-emerald-500">
            <h3 class="text-xl font-semibold text-white">Reportes</h3>
            <p class="mt-2 text-sm text-gray-100">Ver porcentajes y cerrar cursadas.</p>
        </a>

        <!-- Armar Cursada -->
        <a href="{{ route('asistencias.armar-cursada') }}"
           class="block bg-white/20 backdrop-blur-md border border-white/30 shadow rounded-lg p-6 hover:bg-white/30 transition border-t-4 border-purple-600">
            <h3 class="text-xl font-semibold text-white">Armar Cursada</h3>
            <p class="mt-2 text-sm text-gray-100">Gestionar alumnos por comisión.</p>
        </a>
    </div>

      <!-- Botón de cierre/cancelar -->
<div class="flex justify-center mt-6">
    <a href="{{ route('panel') }}"
       class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded">
        Volver al Panel
    </a>
</x-app-interno-layout>
