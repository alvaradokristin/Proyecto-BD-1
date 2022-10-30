using System.ComponentModel.DataAnnotations;

namespace BasesP1.Models
{
    public class Producto
    {
        [Key]
        [Required]
        public string? Codigo { get; set; }
        public string? Nombre { get; set; }
        public string? Activo { get; set; }
        public string? Descripcion { get; set; }

        [Display(Name = "Precio Estandar")]
        public float? PrecioEstandar { get; set; }

        [Display(Name = "Codigo de Familia Producto")]
        public string? Codigo_familia { get; set; }

    }
}
