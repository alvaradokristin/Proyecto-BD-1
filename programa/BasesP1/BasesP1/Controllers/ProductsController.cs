using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BasesP1.Controllers
{
    public class ProductsController : Controller
    {
        private readonly SistemaCRMContext _context;

        public ProductsController(SistemaCRMContext context)
        {
            _context = context;
        }

        // GET: Products
        public async Task<IActionResult> Index()
        {
            return View(await _context.Producto.ToListAsync());
        }

        // GET: Products/ShowProducts/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.Producto == null)
            {
                return NotFound();
            }

            var producto = await _context.Producto
                .FirstOrDefaultAsync(m => m.Codigo == id);
            if (producto == null)
            {
                return NotFound();
            }

            return View(producto);
        }
        public IActionResult AddProduct()
        {
            return View();
        }
    }
}
