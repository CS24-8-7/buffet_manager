import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/cart_item.dart';
import 'package:flutter/services.dart' show rootBundle;


class PrintService {
  static Future<void> printInvoice(
      List<CartItem> items,
      double total,
      DateTime date, {
        String? cashierName,
        String? notes,
        int? invoiceNumber,
      }) async {
    try {
      final pdf = pw.Document();

      final arabicFont = pw.Font.ttf(
          await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf"));

      // Theme مع الخط العربي
      final theme = pw.ThemeData.withFont(
        base: arabicFont,
        bold: arabicFont,
        italic: arabicFont,
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll80,
          margin: const pw.EdgeInsets.all(12),
          theme: theme,
          build: (context) {
            return pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  pw.SizedBox(height: 15),
                  _buildInvoiceInfo(invoiceNumber, date, cashierName),
                  pw.SizedBox(height: 15),
                  _buildItemsTable(items),
                  pw.SizedBox(height: 15),
                  _buildTotalSection(total),
                  if (notes != null && notes.isNotEmpty) ...[
                    pw.SizedBox(height: 15),
                    _buildNotesSection(notes),
                  ],
                  pw.SizedBox(height: 20),
                  _buildFooter(),
                ],
              ),
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name:
        'فاتورة_${invoiceNumber ?? DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      debugPrint("خطأ في طباعة الفاتورة: $e");
      rethrow;
    }
  }

  // Header
  static pw.Widget _buildHeader() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue300, width: 2),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Container(
            width: 60,
            height: 60,
            decoration: pw.BoxDecoration(
              color: PdfColors.blue600,
              borderRadius: pw.BorderRadius.circular(30),
            ),
            child: pw.Center(
              child: pw.Text(
                'مطعم الأصالة',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.black,
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text('مطعم الأصالة'),
          pw.Text('نقدم لكم أشهى الأطباق الشرقية والغربية'),
        ],
      ),
    );
  }

  // Invoice Info
  static pw.Widget _buildInvoiceInfo(
      int? invoiceNumber, DateTime date, String? cashierName) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(child: pw.Text('فاتورة مبيعات')),
          pw.SizedBox(height: 8),
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: 5),
          _buildInfoRow('رقم الفاتورة', invoiceNumber?.toString() ?? 'غير محدد'),
          _buildInfoRow('التاريخ', DateFormat("dd/MM/yyyy").format(date)),
          _buildInfoRow('الوقت', DateFormat("HH:mm").format(date)),
          if (cashierName != null) _buildInfoRow('الكاشير', cashierName),
        ],
      ),
    );
  }

  // Items Table
  static pw.Widget _buildItemsTable(List<CartItem> items) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Table(
        border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey300),
        defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
        columnWidths: {
          0: const pw.FlexColumnWidth(3),
          1: const pw.FlexColumnWidth(1),
          2: const pw.FlexColumnWidth(2),
          3: const pw.FlexColumnWidth(2),
        },
        children: [
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.blue600),
            children: ['المنتج', 'الكمية', 'السعر', 'الإجمالي']
                .map((e) => _buildTableCell(e, isHeader: true))
                .toList(),
          ),
          ...List.generate(
            items.length,
                (i) => pw.TableRow(
              decoration: pw.BoxDecoration(
                color: i % 2 == 0 ? PdfColors.white : PdfColors.grey50,
              ),
              children: [
                _buildTableCell(items[i].product.name),
                _buildTableCell(items[i].quantity.toString()),
                _buildTableCell('${items[i].product.price.toStringAsFixed(2)} ر.س'),
                _buildTableCell('${items[i].totalPrice.toStringAsFixed(2)} ر.س'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Total Section
  static pw.Widget _buildTotalSection(double total) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        border: pw.Border.all(color: PdfColors.green300, width: 2),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('الإجمالي الكلي:', style: const pw.TextStyle(fontSize: 14)),
          pw.Text('${total.toStringAsFixed(2)} ريال سعودي',
              style: const pw.TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // Notes
  static pw.Widget _buildNotesSection(String notes) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.amber50,
        border: pw.Border.all(color: PdfColors.amber300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('ملاحظات:', style:  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text(notes),
        ],
      ),
    );
  }

  // Footer
  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 10),
        pw.Text('شكراً لزيارتكم - نرجو منكم زيارتنا مرة أخرى'),
        pw.Text('للشكاوى والاقتراحات: 966123456789+'),
        pw.SizedBox(height: 8),
        pw.Divider(color: PdfColors.grey300),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(DateFormat('dd/MM/yyyy - HH:mm').format(DateTime.now()),
                style: const pw.TextStyle(fontSize: 8)),
            pw.Text('نظام إدارة المطاعم v1.0', style: const pw.TextStyle(fontSize: 8)),
          ],
        ),
      ],
    );
  }

  // Helpers
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text('$label:', style:  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(value),
      ],
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: isHeader ? 11 : 9,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }
}
