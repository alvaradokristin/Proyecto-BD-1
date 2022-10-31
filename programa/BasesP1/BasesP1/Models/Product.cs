using System.ComponentModel.DataAnnotations;

namespace BasesP1.Models
{

    //Model with the columns from the Producto table
    public class Product
    {
        [Key]
        [Required]
        [StringLength(10)]
        public string? Codigo { get; set; }

        [Required]
        [StringLength(12)]
        public string? Nombre { get; set; }

        [Required]
        public Boolean? Activo { get; set; }

        [Required]
        [StringLength(30)]
        public string? Descripcion { get; set; }

        [Display(Name = "Precio Estandar")]
        public decimal? PrecioEstandar { get; set; }

        [Required]
        [StringLength(10)]
        [Display(Name = "Codigo de Familia Producto")]
        public string? CodigoFamilia { get; set; }

    }
}
