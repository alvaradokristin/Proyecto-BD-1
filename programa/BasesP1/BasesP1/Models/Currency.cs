using System.ComponentModel.DataAnnotations;

namespace BasesP1.Models
{
    public class Currency
    {
        [Key]
        [Required]
        [StringLength(4)]
        public string? abreviatura { get; set; }

        [Key]
        [Required]
        [StringLength(12)]
        public string? nombre { get; set; }
    }
}
