document.addEventListener('DOMContentLoaded', () => {
    let personaSeleccionada = null;

    const txtBusqueda = document.getElementById('txtBusqueda');
    const btnBuscar = document.getElementById('btnBuscar');
    const resultados = document.getElementById('resultados');
    const panelPersona = document.getElementById('panelPersona');
    const datosPersona = document.getElementById('datosPersona');
    const panelProducto = document.getElementById('panelProducto');
    const formProducto = document.getElementById('formProducto');
    const mensaje = document.getElementById('mensaje');
    const listaProductosPersona = document.getElementById('listaProductosPersona');

    const tipoProducto = document.getElementById('C_id_tipo_producto');
    const nombreProducto = document.getElementById('D_nombre');
    const lblMonto = document.getElementById('lblMonto');
    const grupoIngresos = document.getElementById('grupoIngresos');
    const inputIngresos = document.getElementById('N_ingresos');

    const nombresProductos = {
        1: 'Cuenta Vista',
        2: 'Depósito a Plazo',
        3: 'Cuenta Expediente Simplificado',
        4: 'Cuenta Planilla',
        5: 'Depósito Judicial',
        6: 'Crédito Directo',
        7: 'Crédito Hipotecario',
        8: 'Tarjeta de Crédito',
        9: 'Línea de Crédito',
        10: 'Descuento de Facturas',
        11: 'Arrendamiento Financiero',
        12: 'Aval y Garantía',
        13: 'Transferencia de Fondos',
        14: 'Remesa',
        15: 'Compra Venta de Divisas',
        16: 'Fideicomiso',
        17: 'Cajero Automático',
        18: 'Banca en Línea',
        19: 'Caja de Seguridad'
    };

    if (tipoProducto) {
        tipoProducto.addEventListener('change', () => {
            if (nombreProducto) {
                nombreProducto.value = nombresProductos[tipoProducto.value] || '';
            }

            actualizarEtiquetaMonto(tipoProducto.value);
        });
    }

    if (btnBuscar) {
        btnBuscar.addEventListener('click', buscarPersona);
    }

    if (txtBusqueda) {
        txtBusqueda.addEventListener('keyup', (event) => {
            if (event.key === 'Enter') {
                buscarPersona();
            }
        });
    }

    if (formProducto) {
        formProducto.addEventListener('submit', crearEscenarioManual);
    }

    async function buscarPersona() {
        const termino = txtBusqueda.value.trim();

        limpiarMensaje();
        resultados.innerHTML = '';

        if (panelPersona) {
            panelPersona.classList.add('oculto');
        }

        if (panelProducto) {
            panelProducto.classList.add('oculto');
        }

        personaSeleccionada = null;

        if (termino.length < 2) {
            resultados.innerHTML = '<p class="aviso">Digite al menos 2 caracteres para buscar.</p>';
            return;
        }

        resultados.innerHTML = '<p class="aviso">Buscando coincidencias en el padrón...</p>';

        try {
            const respuesta = await fetch(`/api/padron/autocomplete?q=${encodeURIComponent(termino)}`);
            const datos = await respuesta.json();

            if (!respuesta.ok) {
                throw new Error(datos.error || 'Error al buscar en el padrón.');
            }

            if (datos.length === 0) {
                resultados.innerHTML = '<p class="aviso">No se encontraron personas con ese criterio.</p>';
                return;
            }

            resultados.innerHTML = '';

            datos.forEach(persona => {
                const div = document.createElement('div');
                div.className = 'resultado';

                div.innerHTML = `
                    <div>
                        <strong>${persona.Nombre || ''} ${persona.PrimerApellido || ''} ${persona.SegundoApellido || ''}</strong>
                        <span>Cédula: ${persona.Cedula || 'No disponible'}</span>
                        <span>${persona.Provincia || ''}${persona.Canton ? ' / ' + persona.Canton : ''}${persona.Distrito ? ' / ' + persona.Distrito : ''}</span>
                    </div>
                    <button type="button">Seleccionar</button>
                `;

                div.querySelector('button').addEventListener('click', () => {
                    seleccionarPersona(persona.Cedula);
                });

                resultados.appendChild(div);
            });

        } catch (error) {
            resultados.innerHTML = `<p class="error">${error.message}</p>`;
        }
    }

    async function seleccionarPersona(cedula) {
        limpiarMensaje();

        try {
            const respuesta = await fetch(`/api/padron/buscar?D_cedula=${encodeURIComponent(cedula)}`);
            const datos = await respuesta.json();

            if (!respuesta.ok) {
                throw new Error(datos.error || 'Error al cargar la persona.');
            }

            if (datos.length === 0) {
                throw new Error('No se encontró la persona seleccionada.');
            }

            personaSeleccionada = datos[0];

            resultados.innerHTML = `
                <div class="resultado resultado-seleccionado">
                    <div>
                        <strong>${personaSeleccionada.Nombre || ''} ${personaSeleccionada.PrimerApellido || ''} ${personaSeleccionada.SegundoApellido || ''}</strong>
                        <span>Cédula: ${personaSeleccionada.Cedula || 'No disponible'}</span>
                        <span>Persona seleccionada correctamente</span>
                    </div>
                    <button type="button" id="btnCambiarPersona">Cambiar</button>
                </div>
            `;

            const btnCambiarPersona = document.getElementById('btnCambiarPersona');

            if (btnCambiarPersona) {
                btnCambiarPersona.addEventListener('click', limpiarSeleccion);
            }

            datosPersona.innerHTML = `
                <p><strong>Nombre:</strong><br>${personaSeleccionada.Nombre || ''} ${personaSeleccionada.PrimerApellido || ''} ${personaSeleccionada.SegundoApellido || ''}</p>
                <p><strong>Cédula:</strong><br>${personaSeleccionada.Cedula || 'No disponible'}</p>
                <p><strong>Provincia:</strong><br>${personaSeleccionada.Provincia || 'No disponible'}</p>
                <p><strong>Cantón:</strong><br>${personaSeleccionada.Canton || 'No disponible'}</p>
                <p><strong>Distrito:</strong><br>${personaSeleccionada.Distrito || 'No disponible'}</p>
                <p><strong>Cliente registrado:</strong><br>${personaSeleccionada.B_es_cliente ? 'Sí' : 'No'}</p>
                <p><strong>Productos actuales:</strong><br>${personaSeleccionada.N_cantidad_productos || 0}</p>
            `;

            controlarCampoIngresos();

            if (panelPersona) {
                panelPersona.classList.remove('oculto');
            }

            if (panelProducto) {
                panelProducto.classList.remove('oculto');
            }

            await cargarProductosPersona(personaSeleccionada.Cedula);

            mostrarAviso('Persona seleccionada. Ahora puede agregarle un producto financiero.');

            setTimeout(() => {
                if (panelProducto) {
                    panelProducto.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            }, 200);

        } catch (error) {
            mostrarError(error.message);
        }
    }

    function limpiarSeleccion() {
        personaSeleccionada = null;

        if (panelPersona) {
            panelPersona.classList.add('oculto');
        }

        if (panelProducto) {
            panelProducto.classList.add('oculto');
        }

        resultados.innerHTML = '';
        limpiarMensaje();

        if (txtBusqueda) {
            txtBusqueda.focus();
        }
    }

    function controlarCampoIngresos() {
        if (!grupoIngresos || !inputIngresos || !personaSeleccionada) {
            return;
        }

        if (personaSeleccionada.B_es_cliente) {
            grupoIngresos.classList.add('oculto');
            inputIngresos.required = false;
            inputIngresos.value = 0;
        } else {
            grupoIngresos.classList.remove('oculto');
            inputIngresos.required = true;
            inputIngresos.value = '';
        }
    }

    async function cargarProductosPersona(cedula) {
        if (!listaProductosPersona) {
            return;
        }

        listaProductosPersona.innerHTML = '<p class="aviso">Cargando productos...</p>';

        try {
            const respuesta = await fetch(`/api/escenario/productos-persona?cedula=${encodeURIComponent(cedula)}`);
            const productos = await respuesta.json();

            if (!respuesta.ok) {
                throw new Error(productos.error || 'Error al cargar productos.');
            }

            if (productos.length === 0) {
                listaProductosPersona.innerHTML = '<p class="aviso">Esta persona todavía no tiene productos registrados.</p>';
                return;
            }

            let html = `
                <div class="tabla-contenedor">
                    <table class="tabla-productos">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tipo</th>
                                <th>Producto</th>
                                <th>Monto</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
            `;

            productos.forEach(producto => {
                html += `
                    <tr>
                        <td>${producto.C_id_producto}</td>
                        <td>${producto.TipoProducto || 'No definido'}</td>
                        <td>${producto.NombreProducto || 'Sin nombre'}</td>
                        <td>₡${Number(producto.M_monto || 0).toLocaleString('es-CR')}</td>
                        <td>
                            <span class="${producto.B_activo ? 'estado-activo' : 'estado-inactivo'}">
                                ${producto.B_activo ? 'Activo' : 'Inactivo'}
                            </span>
                        </td>
                    </tr>
                `;
            });

            html += `
                        </tbody>
                    </table>
                </div>
            `;

            listaProductosPersona.innerHTML = html;

        } catch (error) {
            listaProductosPersona.innerHTML = `<p class="error">${error.message}</p>`;
        }
    }

    async function crearEscenarioManual(event) {
        event.preventDefault();

        if (!personaSeleccionada) {
            mostrarError('Primero debe seleccionar una persona del padrón.');
            return;
        }

        const producto = {
            C_id_tipo_producto: Number(document.getElementById('C_id_tipo_producto').value),
            D_nombre: document.getElementById('D_nombre').value.trim(),
            M_monto: Number(document.getElementById('M_monto').value),
            N_ingresos: Number(document.getElementById('N_ingresos').value || 0)
        };

        if (!producto.C_id_tipo_producto || !producto.D_nombre || !producto.M_monto) {
            mostrarError('Complete los datos del producto.');
            return;
        }

        if (!personaSeleccionada.B_es_cliente && !producto.N_ingresos) {
            mostrarError('Debe indicar los ingresos del cliente para registrarlo por primera vez.');
            return;
        }

        mostrarAviso('Creando escenario manual...');

        try {
            const respuesta = await fetch('/api/escenario/manual', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    persona: personaSeleccionada,
                    producto: producto
                })
            });

            const datos = await respuesta.json();

            if (!respuesta.ok) {
                throw new Error(datos.error || 'No se pudo crear el escenario.');
            }

            mostrarExito(`Escenario creado correctamente. Cliente ID: ${datos.C_id_cliente}, Producto ID: ${datos.C_id_producto}`);

            formProducto.reset();

            if (lblMonto) {
                lblMonto.textContent = 'Monto';
            }

            await seleccionarPersona(personaSeleccionada.Cedula);

        } catch (error) {
            mostrarError(error.message);
        }
    }

    function actualizarEtiquetaMonto(tipo) {
        const etiquetas = {
            1: 'Saldo inicial',
            2: 'Monto del depósito',
            3: 'Saldo inicial',
            4: 'Monto de planilla o servicios',
            5: 'Monto judicial',
            6: 'Monto del crédito directo',
            7: 'Monto del crédito hipotecario',
            8: 'Límite de tarjeta de crédito',
            9: 'Límite de línea de crédito',
            10: 'Monto de factura',
            11: 'Monto del arrendamiento',
            12: 'Monto de aval o garantía',
            13: 'Monto de transferencia',
            14: 'Monto de remesa',
            15: 'Monto de compra/venta de divisas',
            16: 'Monto del fideicomiso',
            17: 'Monto de operación en cajero',
            18: 'Monto de referencia',
            19: 'Monto de caja de seguridad'
        };

        if (lblMonto) {
            lblMonto.textContent = etiquetas[tipo] || 'Monto';
        }
    }

    function mostrarExito(texto) {
        mensaje.className = 'exito';
        mensaje.textContent = texto;
    }

    function mostrarError(texto) {
        mensaje.className = 'error';
        mensaje.textContent = texto;
    }

    function mostrarAviso(texto) {
        mensaje.className = 'aviso';
        mensaje.textContent = texto;
    }

    function limpiarMensaje() {
        mensaje.className = '';
        mensaje.textContent = '';
    }
});