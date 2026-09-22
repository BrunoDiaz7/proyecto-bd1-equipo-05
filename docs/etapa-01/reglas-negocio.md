# Reglas de Negocio

### RN01 - Historial e Inmutabilidad de Precios
Toda línea correspondiente a un producto o servicio incluida en una operación debe almacenar el precio unitario aplicado al momento de realizar la operación. Los cambios aplicados posteriormente en el precio del producto o tarifa del servicio no modifican los importes registrados en operaciones anteriores.

### RN02 - Control de Stock
Un producto solo podrá ser vendido o utilizado como componente de un servicio cuando exista stock suficiente para cubrir la cantidad solicitada. Una vez confirmada la operación, el sistema deberá actualizar el stock disponible.

### RN03 - Registro de Clientes
Toda operación registrada en el sistema deberá estar asociada a un cliente previamente registrado. Cada cliente debe tener un identificador único, nombre, apellido y teléfono de contacto.

### RN04 - Métodos de Pago
Toda operación que implique un cobro deberá estar asociada a un método de pago habilitado. El sistema solo permitirá utilizar métodos de pago que se encuentren activos al momento de registrar la operación.

### RN05 - Personal Interviniente
Toda operación deberá registrar el personal responsable de su realización.

### RN06 - Clasificación de Productos
Cada producto deberá pertenecer obligatoriamente a una única categoría y estar asociado a una marca o fabricante.

### RN07 - Identificación Única de Productos
Cada producto deberá poseer un identificador único dentro del sistema.

### RN08 - Integridad de las Operaciones
Una operación deberá registrarse de forma completa, incluyendo al menos el cliente, fecha, productos y/o servicios involucrados, método de pago y el personal interviniente.

### RN09 - Registro de Servicios
Cada servicio técnico realizado deberá estar asociado a un cliente y a un técnico responsable. Cuando durante la prestación del servicio se utilicen productos o componentes del inventario, estos deberán registrarse en la operación para permitir el control del stock.

### RN10 - Roles de personal.
Cada empleado del negocio puede desempeñar tareas tanto de ventas como de servicio técnico y asesoría.