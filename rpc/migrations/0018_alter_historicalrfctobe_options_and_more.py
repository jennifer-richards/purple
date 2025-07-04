# Copyright The IETF Trust 2025, All Rights Reserved

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("datatracker", "0004_historicaldatatrackerperson"),
        ("rpc", "0017_blankable_rpcrelateddocument_targets"),
    ]

    operations = [
        migrations.AlterModelOptions(
            name="historicalrfctobe",
            options={
                "get_latest_by": ("history_date", "history_id"),
                "ordering": ("-history_date", "-history_id"),
                "verbose_name": "historical rfc to be",
                "verbose_name_plural": "historical RfcToBes",
            },
        ),
        migrations.AlterModelOptions(
            name="rfctobe",
            options={"verbose_name_plural": "RfcToBes"},
        ),
        migrations.AlterConstraint(
            model_name="rpcdocumentcomment",
            name="rpcdocumentcomment_exactly_one_target",
            constraint=models.CheckConstraint(
                condition=models.Q(
                    ("document__isnull", True),
                    ("rfc_to_be__isnull", True),
                    _connector="XOR",
                ),
                name="rpcdocumentcomment_exactly_one_target",
                violation_error_message="exactly one of doc or rfc_to_be must be set",
            ),
        ),
    ]
