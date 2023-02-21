import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:tell_sam_admin_panel/modules/staff/Model/staff_record_model.dart';
import 'dart:html' as html;

class PdfService {
  late MemoryImage imageLogo;
  var myFont;
  late TextStyle style;
  init() async {
    imageLogo = MemoryImage(
        (await rootBundle.load('assets/logo.png')).buffer.asUint8List());
    ByteData data = await rootBundle.load("assets/Roboto-Medium.ttf");
    myFont = Font.ttf(data);
    style = TextStyle(font: myFont);
  }

  makePdf(context, String staffName, int totalHrs,
      List<StaffRecord> records) async {
    final pdf = Document();
    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return Column(children: [
            _getHeader(staffName, totalHrs),
            Table(border: TableBorder.all(color: PdfColors.black), children: [
              TableRow(children: [
                _paddedText('Location'),
                _paddedText('Date'),
                _paddedText('Clock In'),
                _paddedText('Clock Out'),
                _paddedText('Total Hours'),
              ]),
              ...records
                  .map<TableRow>((e) => TableRow(children: [
                        _paddedText('${e.LocationName}'),
                        _paddedText('${e.date}'),
                        _paddedText('${e.clockIn}'),
                        _paddedText('${e.clockOut}'),
                        _paddedText('${e.totalHrsSpent}'),
                      ]))
                  .toList()
            ])
          ]);
        }));

    Uint8List pdfInBytes = await pdf.save();

    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '$staffName.pdf';
    html.document.body?.children.add(anchor);
    anchor.click();
  }

  _getHeader(String staffName, int hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Staff name: $staffName", style: style),
            Text("Total Hours worked: $hours", style: style),
          ],
        ),
        SizedBox(
          height: 150,
          width: 150,
          child: Image(imageLogo),
        )
      ],
    );
  }

  _paddedText(String text) {
    return Padding(
        padding: const EdgeInsets.all(8), child: Text(text, style: style));
  }
}
